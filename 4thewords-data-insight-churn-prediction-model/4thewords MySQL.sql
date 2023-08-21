#file count created in 7 day
SELECT wf.iduser , COUNT(wf.iduser) AS file_count 
FROM write_files wf 
LEFT JOIN app_users au 
ON wf.iduser = au.id
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 31 DAY)
	AND au.created_at <= wf.created_at 
	AND DATEDIFF(DATE(wf.created_at), DATE(au.created_at)) <= 7
GROUP BY wf.iduser

 #wardrobe_update binary
SELECT
  hs.iduser,
  CASE
    WHEN hs.iduser IS NOT NULL THEN 1
    ELSE 0
  END AS wardrobe_updated
FROM
  hero_stats hs
  LEFT JOIN app_users au ON hs.iduser = au.id
WHERE
  CASE
    WHEN hs.iduser IS NOT NULL THEN 1
    ELSE 0
  END = 1
  AND au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND hs.avatar_md NOT LIKE '%\\_option\\_%'
  AND hs.avatar_md NOT LIKE '%/placeholders/%'
  AND hs.avatar_sm NOT LIKE '%\\_option\\_%'
  AND hs.avatar_sm NOT LIKE '%/placeholders/%'

  
 #wordcount in 7 days
SELECT ww.iduser, SUM(words) AS wordcount
FROM write_wordcount ww 
LEFT JOIN app_users au 
ON ww.iduser = au.id 
WHERE 
    au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    AND (DATE(au.created_at) <= ww.date) 
    AND DATEDIFF(ww.date, DATE(au.created_at)) <= 7
GROUP BY iduser


#mission_count in 7 days
SELECT hmh.idhero, COUNT(hmh.idhero) AS mission_count
FROM hero_missions_history hmh 
JOIN app_users au ON hmh.idhero = au.idhero 
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND au.created_at <= hmh.created_at 
  AND DATEDIFF(DATE(hmh.created_at), DATE(au.created_at)) <= 7
GROUP BY hmh.idhero;

#battle count in 7 days
SELECT hbh.idhero, COUNT( hbh.idhero) AS battle_count
FROM hero_battle_history hbh 
LEFT JOIN app_users au ON hbh.idhero = au.idhero
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
AND (DATE(au.created_at) <= DATE(hbh.start)) 
AND DATEDIFF(DATE(hbh.start), DATE(au.created_at)) <= 7
GROUP BY hbh.idhero;

#chat count in 7 days
SELECT DISTINCT idsender AS iduser, COUNT(DISTINCT idchat) AS chat_count
FROM app_user_chat_messages aucm
LEFT JOIN app_users au ON aucm.idsender = au.id
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
	AND (DATE(au.created_at) <= DATE(aucm.created_at))
    AND DATEDIFF(DATE(aucm.created_at), DATE(au.created_at)) <= 7
GROUP BY idsender;

#inventory count in 7 days
SELECT hi.idhero, COUNT(DISTINCT iditem) AS num_items
FROM hero_inventory hi 
LEFT JOIN app_users au 
ON hi.idhero = au.idhero 
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
	AND (DATE(au.created_at) <= DATE(hi.created_at))
    AND DATEDIFF(DATE(hi.created_at), DATE(au.created_at)) <= 7
GROUP BY idhero;

#hero_area binary if larger than 1
SELECT ha.idhero, 
    CASE
        WHEN COUNT(DISTINCT ha.idarea) > 1 THEN 1
        ELSE 0
    END AS larger_than_one
FROM hero_areas ha
LEFT JOIN app_users au ON ha.idhero = au.idhero
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
	AND (DATE(au.created_at) <= DATE(ha.created_at))
    AND DATEDIFF(DATE(ha.created_at), DATE(au.created_at)) <= 7
GROUP BY ha.idhero;

#user friends in 7 days
SELECT host_id AS iduser, COUNT(host_id) AS friends_amount
FROM app_userfriends au2  
LEFT JOIN app_users au 
ON au2.host_id  = au.id
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
	AND (DATE(au.created_at) <= DATE(au2.created_at))
    AND DATEDIFF(DATE(au2.created_at), DATE(au.created_at)) <= 7
GROUP BY host_id 

#streak iduser with date 
SELECT ws.iduser, ws.count AS streak_count
FROM write_streaks ws
LEFT JOIN app_users au ON ws.iduser = au.id
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND ws.end_date >= DATE(au.created_at)
  AND DATEDIFF(ws.end_date, DATE(au.created_at)) <= 7
  AND ws.count <= 30
  AND ws.count = (
    SELECT MAX(count)
    FROM write_streaks
    WHERE iduser = ws.iduser
  )
 GROUP BY ws.iduser;

#iduser and idhero within 30 days
SELECT id AS iduser, idhero
FROM app_users au 
WHERE au.created_at >= DATE_SUB(CURDATE(), INTERVAL 31 DAY)
