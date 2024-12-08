-- Day 1: Santa's Gift List Parser

SELECT
	c.name,
	w.primary_wish,
	w.backup_wish,
	w.favorite_color,
	w.color_count,
	t.gift_complexity,
	t.workshop_assignment
FROM children AS c
LEFT JOIN (
	SELECT
		child_id,
		substring((wishes::json->'first_choice')::text FROM '"(.*?)"') AS primary_wish,
		substring((wishes::json->'second_choice')::text FROM '"(.*?)"') AS backup_wish,
		substring((wishes::json->'colors')::text FROM '"(.*?)"') AS favorite_color,
		length((wishes::json->'colors')::text) - length(replace((wishes::json->'colors')::text, ',', '')) + 1 AS color_count
	FROM wish_lists
) AS w ON c.child_id = w.child_id
LEFT JOIN (
	SELECT
		toy_name,
	  	CASE
		    WHEN difficulty_to_make = 1 THEN 'Simple Gift'
		    WHEN difficulty_to_make = 2 THEN 'Moderate Gift'
		    WHEN difficulty_to_make >= 3 THEN 'Complex Gift'
		    ELSE 'Unknown'
		END AS gift_complexity,
		CASE
		    WHEN category = 'outdoor' THEN 'Outside Workshop'
		    WHEN category = 'educational' THEN 'Learning Workshop'
		    ELSE 'General Workshop'
		END AS workshop_assignment
FROM toy_catalogue
) AS t on w.primary_wish = t.toy_name
ORDER BY name;
