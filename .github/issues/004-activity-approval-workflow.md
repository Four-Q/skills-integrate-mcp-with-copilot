 # Implement activity/appointment approval workflow
 Labels: enhancement,priority:medium

Description
-----------
Introduce a workflow where student signups can be `pending` and require teacher/admin approval before being finalized.

Acceptance criteria
-------------------
- Signup records include a status field (`pending`, `approved`, `rejected`).
- Teachers/admins can view pending signups and approve/reject them via API or admin UI.
- Students see signup status in their personal center.

Tasks
-----
- Add `status` to `Signup` model and DB migrations.
- Add endpoints for listing pending signups and approving/rejecting.
- Frontend: show signup status and admin approval UI.
