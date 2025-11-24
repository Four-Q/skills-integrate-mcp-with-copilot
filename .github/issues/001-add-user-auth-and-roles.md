 # Add user authentication and role-based access control
 Labels: enhancement,priority:high

Description
-----------
Add a user model and authentication system so the app can distinguish Admin / Teacher / Student / Guest roles. Replace the current anonymous operations with protected endpoints.

Acceptance criteria
-------------------
- Users can register and log in (email + password).
- Passwords are stored hashed.
- JWT or session-based auth is issued on login and required for protected endpoints.
- Roles: `admin`, `teacher`, `student` assigned at registration or by admin.
- Protected endpoints: activity management, approval endpoints, admin-only CRUD.

Tasks
-----
- Add `User` model (id, email, password_hash, role).
- Integrate auth library (recommend `fastapi-users` or JWT + `passlib`).
- Add `/auth/register` and `/auth/login` endpoints.
- Add dependency for role-based access control on sensitive routes.

Notes
-----
Start with SQLite + SQLAlchemy for persistence; keep endpoints backward compatible where possible.
