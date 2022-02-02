-- Create retirement titles table 
SELECT e.emp_no, 
e.first_name,
e.last_name, 
tt.title,
tt.from_date,
tt.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as tt
ON (e.emp_no = tt.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Use Distinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Retrieve number of employees by most recent title who are about to retire
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.title) DESC;

-- Create mentorship-eligibility table 
SELECT DISTINCT ON (emp_no) e.emp_no, 
e.first_name,
e.last_name, 
e.birth_date,
de.from_date,
de.to_date,
tt.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as tt
ON (e.emp_no = tt.emp_no)
WHERE (de.to_date = '9999-01-01') AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;

-- Retrieve number of mentorship-eligibility employees by title
SELECT COUNT (mem.emp_no),
mem.title
INTO ment_elig_numb
FROM mentorship_eligibility as mem
GROUP BY mem.title

-- Create table with retirement titles and birth_date
SELECT ut.title,
ut.emp_no,
ret.to_date,
e.birth_date
INTO ret_title_by_year
FROM unique_titles as ut
INNER JOIN retirement_titles as ret
ON (ut.emp_no = ret.emp_no)
INNER JOIN employees as e
ON (ut.emp_no = e.emp_no)
WHERE (ret.to_date = '9999-01-01') AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY ut.emp_no ASC; 

-- Return number of retiring employees by birth year
SELECT EXTRACT (year from birth_date) as year,
COUNT(*) AS emp_no
FROM ret_title_by_year
GROUP BY 1
ORDER BY year ASC;