 # Add class management and roster features
 Labels: enhancement,priority:low

Description
-----------
Support classes, class membership, and the ability to run class-specific activities and announcements.

Acceptance criteria
-------------------
- `Class` model with relationships to `User` (students and teachers).
- Admin/teacher can create classes and assign students.
- Activities and notices can be targeted to classes.

Tasks
-----
- Add `Class` model and CRUD endpoints.
- Frontend: class pages and roster view.
