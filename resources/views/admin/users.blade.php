@extends('admin.partials.layouts.master')

@section('title', 'Users — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Users')
@section('buttonTitle', '+ Add User')
@section('modalTarget', 'addUserModal')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-group-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Users</p><h4 class="mb-0 fw-semibold">{{ $users->total() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-building-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Employers</p><h4 class="mb-0 fw-semibold">{{ \App\Models\User::employers()->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-info-subtle text-info rounded-2"><i class="ri-user-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Candidates</p><h4 class="mb-0 fw-semibold">{{ \App\Models\User::candidates()->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-danger-subtle text-danger rounded-2"><i class="ri-shield-star-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Admins</p><h4 class="mb-0 fw-semibold">{{ \App\Models\User::admins()->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search name or email..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="role" class="form-select form-select-sm">
                    <option value="">All Roles</option>
                    <option value="admin" {{ request('role')==='admin'?'selected':'' }}>Admin</option>
                    <option value="employer" {{ request('role')==='employer'?'selected':'' }}>Employer</option>
                    <option value="candidate" {{ request('role')==='candidate'?'selected':'' }}>Candidate</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="status" class="form-select form-select-sm">
                    <option value="">All Statuses</option>
                    <option value="active" {{ request('status')==='active'?'selected':'' }}>Active</option>
                    <option value="blocked" {{ request('status')==='blocked'?'selected':'' }}>Blocked</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.users') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Users Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Telegram</th>
                        <th>Joined</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($users as $user)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $user->id }}"></td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                @if($user->avatar)
                                    <img src="{{ asset('storage/'.$user->avatar) }}" class="rounded-circle" width="32" height="32" alt="">
                                @else
                                    <div class="avatar-item avatar-xs avatar-title rounded-circle text-white" style="background:var(--bs-primary);font-size:11px;width:32px;height:32px;">{{ strtoupper(substr($user->name,0,1)) }}</div>
                                @endif
                                <span class="fw-medium">{{ $user->name }}</span>
                            </div>
                        </td>
                        <td class="text-muted">{{ $user->email }}</td>
                        <td>
                            @php $rc = match($user->role->value){ 'admin'=>'danger','employer'=>'primary','candidate'=>'success',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $rc }}-subtle text-{{ $rc }}">{{ ucfirst($user->role->value) }}</span>
                        </td>
                        <td>
                            @if(($user->status ?? 'active') === 'active')
                                <span class="badge bg-success-subtle text-success"><i class="ri-checkbox-circle-line me-1"></i>Active</span>
                            @else
                                <span class="badge bg-danger-subtle text-danger"><i class="ri-close-circle-line me-1"></i>Blocked</span>
                            @endif
                        </td>
                        <td>
                            @if($user->telegram_username)
                                <a href="https://t.me/{{ $user->telegram_username }}" target="_blank" class="text-info"><i class="ri-telegram-line me-1"></i>{{ '@'.$user->telegram_username }}</a>
                            @else
                                <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td class="text-muted fs-12">{{ $user->created_at->format('M d, Y') }}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item view-user-btn" href="#" data-bs-toggle="modal" data-bs-target="#viewUserModal" data-user='@json($user)'><i class="ri-eye-line me-2"></i>View</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="ri-edit-line me-2"></i>Edit</a></li>
                                    @if(($user->status ?? 'active') === 'active')
                                        <li><a class="dropdown-item text-warning" href="#"><i class="ri-forbid-line me-2"></i>Block</a></li>
                                    @else
                                        <li><a class="dropdown-item text-success" href="#"><i class="ri-checkbox-circle-line me-2"></i>Activate</a></li>
                                    @endif
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="ri-delete-bin-line me-2"></i>Delete</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="ri-user-line fs-1 d-block mb-2 opacity-50"></i>No users found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($users->hasPages())
    <div class="card-footer">{{ $users->withQueryString()->links() }}</div>
    @endif
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Add User</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addUserForm">
                    <div class="mb-3"><label class="form-label">Full Name</label><input type="text" class="form-control" name="name" required></div>
                    <div class="mb-3"><label class="form-label">Email</label><input type="email" class="form-control" name="email" required></div>
                    <div class="mb-3"><label class="form-label">Password</label><input type="password" class="form-control" name="password" required minlength="8"></div>
                    <div class="row mb-3">
                        <div class="col-6"><label class="form-label">Role</label><select class="form-select" name="role"><option value="candidate">Candidate</option><option value="employer">Employer</option><option value="admin">Admin</option></select></div>
                        <div class="col-6"><label class="form-label">Phone</label><input type="text" class="form-control" name="phone" placeholder="+48..."></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary" id="btnAddUser">Create User</button></div>
        </div>
    </div>
</div>

<!-- View User Modal -->
<div class="modal fade" id="viewUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">User Details</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body" id="viewUserBody"></div>
        </div>
    </div>
</div>
@endsection

@section('js')
<script>
document.querySelectorAll('.view-user-btn').forEach(btn=>{
    btn.addEventListener('click',function(){
        const u=JSON.parse(this.dataset.user);
        const rc=u.role==='admin'?'danger':(u.role==='employer'?'primary':'success');
        document.getElementById('viewUserBody').innerHTML=`
            <div class="text-center mb-3">
                <div class="avatar-item avatar avatar-lg avatar-title rounded-circle text-white mx-auto" style="background:var(--bs-primary);font-size:24px;width:64px;height:64px;">${u.name.charAt(0).toUpperCase()}</div>
                <h5 class="mt-2 mb-0">${u.name}</h5><span class="badge bg-${rc}-subtle text-${rc} mt-1">${u.role}</span>
            </div>
            <table class="table table-borderless mb-0">
                <tr><td class="text-muted" style="width:120px">Email</td><td>${u.email}</td></tr>
                <tr><td class="text-muted">Phone</td><td>${u.phone||'—'}</td></tr>
                <tr><td class="text-muted">Status</td><td>${u.status||'active'}</td></tr>
                <tr><td class="text-muted">Telegram</td><td>${u.telegram_username?'@'+u.telegram_username:'—'}</td></tr>
                <tr><td class="text-muted">Joined</td><td>${new Date(u.created_at).toLocaleDateString()}</td></tr>
            </table>`;
    });
});
document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});
</script>
@endsection
