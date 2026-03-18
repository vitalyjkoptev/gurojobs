@extends('admin.partials.layouts.master')

@section('title', 'Dashboard — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Dashboard')

@section('content')
<div class="row g-3 mb-4">
    <!-- Total Users -->
    <div class="col-xl-3 col-md-6">
        <div class="card card-hover card-h-100 border-primary border-3 border-bottom">
            <div class="card-body p-4 d-flex align-items-start gap-3">
                <div class="flex-fill">
                    <h3 class="fw-semibold mb-1">{{ $stats['users'] ?? 0 }}</h3>
                    <h6 class="text-muted mb-0">Total Users</h6>
                </div>
                <i class="ri-group-line display-6 text-muted opacity-50"></i>
            </div>
        </div>
    </div>

    <!-- Active Jobs -->
    <div class="col-xl-3 col-md-6">
        <div class="card card-hover card-h-100 border-success border-3 border-bottom">
            <div class="card-body p-4 d-flex align-items-start gap-3">
                <div class="flex-fill">
                    <h3 class="fw-semibold mb-1">{{ $stats['jobs'] ?? 0 }}</h3>
                    <h6 class="text-muted mb-0">Active Jobs</h6>
                </div>
                <i class="ri-briefcase-line display-6 text-muted opacity-50"></i>
            </div>
        </div>
    </div>

    <!-- Companies -->
    <div class="col-xl-3 col-md-6">
        <div class="card card-hover card-h-100 border-warning border-3 border-bottom">
            <div class="card-body p-4 d-flex align-items-start gap-3">
                <div class="flex-fill">
                    <h3 class="fw-semibold mb-1">{{ $stats['companies'] ?? 0 }}</h3>
                    <h6 class="text-muted mb-0">Companies</h6>
                </div>
                <i class="ri-building-line display-6 text-muted opacity-50"></i>
            </div>
        </div>
    </div>

    <!-- Applications -->
    <div class="col-xl-3 col-md-6">
        <div class="card card-hover card-h-100 border-info border-3 border-bottom">
            <div class="card-body p-4 d-flex align-items-start gap-3">
                <div class="flex-fill">
                    <h3 class="fw-semibold mb-1">{{ $stats['applications'] ?? 0 }}</h3>
                    <h6 class="text-muted mb-0">Applications</h6>
                </div>
                <i class="ri-file-list-3-line display-6 text-muted opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
    <!-- Recent Users -->
    <div class="col-xl-6">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0 flex-grow-1">Recent Users</h5>
                <a href="{{ route('admin.users') }}" class="btn btn-sm btn-subtle-primary">View All</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Joined</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($recentUsers as $user)
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-item avatar-xs avatar-title rounded-circle text-white" style="background: var(--bs-primary); font-size: 11px;">
                                            {{ strtoupper(substr($user->name, 0, 1)) }}
                                        </div>
                                        {{ $user->name }}
                                    </div>
                                </td>
                                <td class="text-muted">{{ $user->email }}</td>
                                <td>
                                    <span class="badge bg-{{ $user->role->value === 'admin' ? 'danger' : ($user->role->value === 'employer' ? 'primary' : 'success') }}-subtle text-{{ $user->role->value === 'admin' ? 'danger' : ($user->role->value === 'employer' ? 'primary' : 'success') }}">
                                        {{ ucfirst($user->role->value) }}
                                    </span>
                                </td>
                                <td class="text-muted">{{ $user->created_at->diffForHumans() }}</td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">No users yet</td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Jobs -->
    <div class="col-xl-6">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0 flex-grow-1">Recent Jobs</h5>
                <a href="{{ route('admin.jobs') }}" class="btn btn-sm btn-subtle-primary">View All</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Title</th>
                                <th>Company</th>
                                <th>Status</th>
                                <th>Posted</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($recentJobs as $job)
                            <tr>
                                <td class="fw-medium">{{ $job->title }}</td>
                                <td class="text-muted">{{ $job->company->name ?? '—' }}</td>
                                <td>
                                    <span class="badge bg-{{ $job->status === 'active' ? 'success' : ($job->status === 'draft' ? 'secondary' : 'warning') }}-subtle text-{{ $job->status === 'active' ? 'success' : ($job->status === 'draft' ? 'secondary' : 'warning') }}">
                                        {{ ucfirst($job->status) }}
                                    </span>
                                </td>
                                <td class="text-muted">{{ $job->created_at->diffForHumans() }}</td>
                            </tr>
                            @empty
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">No jobs yet</td>
                            </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Role Distribution -->
<div class="row g-3 mt-1">
    <div class="col-xl-4">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Users by Role</h5>
            </div>
            <div class="card-body">
                @foreach($roleStats as $role => $count)
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="d-flex align-items-center gap-2">
                        <span class="avatar-item avatar-xs avatar-title rounded-circle bg-{{ $role === 'admin' ? 'danger' : ($role === 'employer' ? 'primary' : 'success') }}-subtle text-{{ $role === 'admin' ? 'danger' : ($role === 'employer' ? 'primary' : 'success') }}" style="font-size: 11px;">
                            <i class="ri-{{ $role === 'admin' ? 'shield-star' : ($role === 'employer' ? 'building' : 'user') }}-line"></i>
                        </span>
                        <span class="fw-medium">{{ ucfirst($role) }}s</span>
                    </div>
                    <span class="badge bg-light text-dark">{{ $count }}</span>
                </div>
                @endforeach
            </div>
        </div>
    </div>

    <div class="col-xl-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Quick Actions</h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <a href="{{ route('admin.users') }}" class="text-decoration-none">
                            <div class="text-center p-3 rounded border">
                                <i class="ri-user-add-line fs-1 text-primary d-block mb-2"></i>
                                <span class="fw-medium">Manage Users</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="{{ route('admin.jobs') }}" class="text-decoration-none">
                            <div class="text-center p-3 rounded border">
                                <i class="ri-briefcase-line fs-1 text-success d-block mb-2"></i>
                                <span class="fw-medium">Manage Jobs</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="{{ route('admin.companies') }}" class="text-decoration-none">
                            <div class="text-center p-3 rounded border">
                                <i class="ri-building-2-line fs-1 text-warning d-block mb-2"></i>
                                <span class="fw-medium">Companies</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="{{ route('admin.settings') }}" class="text-decoration-none">
                            <div class="text-center p-3 rounded border">
                                <i class="ri-settings-3-line fs-1 text-info d-block mb-2"></i>
                                <span class="fw-medium">Settings</span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
