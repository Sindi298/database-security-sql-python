USE CyberSecurityDB;
GO

SELECT * FROM Employees;

SELECT * FROM Systems WHERE criticality_level = 'Critical';

SELECT * FROM Incidents WHERE status = 'Investigating';

SELECT * FROM Users WHERE account_status = 'Active';

SELECT 
    v.vulnerability_name,
    v.cve_code,
    s.system_name
FROM Vulnerabilities v
INNER JOIN Systems s 
    ON v.affected_system_id = s.system_id;


SELECT 
    e.first_name,
    e.last_name,
    st.training_name,
    st.certification_status
FROM Employees e
INNER JOIN Security_Training st 
    ON e.employee_id = st.employee_id;

SELECT * FROM Threats;

SELECT * FROM Users;

SELECT severity, COUNT(*) AS incident_count FROM Incidents GROUP BY severity;

SELECT user_id, COUNT(*) AS log_count FROM Security_Logs GROUP BY user_id;

SELECT severity, COUNT(*) AS vulnerability_count FROM Vulnerabilities GROUP BY severity;