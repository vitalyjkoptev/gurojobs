@extends('admin.partials.layouts.master')

@section('title', 'Search — GURO JOBS Admin')
@section('pagetitle', 'Pages')
@section('sub-title', 'Search Results')

@section('content')

<div class="card">
    <div class="card-body">
        <form method="GET" action="{{ route('admin.search') }}">
            <div class="hstack gap-3 mb-3">
                <div class="form-icon flex-grow-1">
                    <i class="ri-search-line text-muted"></i>
                    <input type="search" name="q" class="form-control form-control-icon" placeholder="Search users, jobs, companies..." value="{{ $q ?? '' }}">
                </div>
                <div class="hstack gap-3 flex-shrink-0">
                    <button class="btn btn-primary" type="submit">Search</button>
                </div>
            </div>
        </form>

        @if($q)
        <div class="hstack flex-wrap gap-2 my-4">
            <span class="badge bg-light text-muted">{{ $q }} <a href="{{ route('admin.search') }}" class="text-muted"><i class="ri-close-line cursor-pointer"></i></a></span>
        </div>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs nav-tabs-bordered" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link active" data-bs-toggle="tab" href="#search-all" role="tab">
                    All Results
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" data-bs-toggle="tab" href="#search-users" role="tab">
                    Users <span class="badge bg-primary-subtle text-primary ms-1">{{ isset($results['users']) ? $results['users']->count() : 0 }}</span>
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" data-bs-toggle="tab" href="#search-jobs" role="tab">
                    Jobs <span class="badge bg-success-subtle text-success ms-1">{{ isset($results['jobs']) ? $results['jobs']->count() : 0 }}</span>
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" data-bs-toggle="tab" href="#search-companies" role="tab">
                    Companies <span class="badge bg-warning-subtle text-warning ms-1">{{ isset($results['companies']) ? $results['companies']->count() : 0 }}</span>
                </a>
            </li>
        </ul>
        @endif
    </div>
</div>

@if($q)
<div class="tab-content mt-3">
    <!-- All Results -->
    <div class="tab-pane active show" id="search-all" role="tabpanel">

        @if(isset($results['users']) && $results['users']->count())
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h6 class="card-title mb-0 flex-grow-1"><i class="ri-group-line me-2 text-primary"></i>Users</h6>
                <span class="badge bg-primary">{{ $results['users']->count() }}</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Joined</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($results['users'] as $user)
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-item avatar-xs avatar-title rounded-circle text-white" style="background:var(--bs-primary);font-size:11px;">{{ strtoupper(substr($user->name,0,1)) }}</div>
                                        <span class="fw-medium">{{ $user->name }}</span>
                                    </div>
                                </td>
                                <td class="text-muted">{{ $user->email }}</td>
                                <td><span class="badge bg-primary-subtle text-primary">{{ ucfirst($user->role->value ?? $user->role) }}</span></td>
                                <td class="text-muted fs-12">{{ $user->created_at->format('M d, Y') }}</td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        @endif

        @if(isset($results['jobs']) && $results['jobs']->count())
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h6 class="card-title mb-0 flex-grow-1"><i class="ri-briefcase-line me-2 text-success"></i>Jobs</h6>
                <span class="badge bg-success">{{ $results['jobs']->count() }}</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Title</th>
                                <th>Company</th>
                                <th>Location</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($results['jobs'] as $job)
                            <tr>
                                <td class="fw-medium">{{ $job->title }}</td>
                                <td class="text-muted">{{ $job->company?->name ?? '—' }}</td>
                                <td class="text-muted">{{ $job->location ?? '—' }}</td>
                                <td>
                                    @php $jsc = match($job->status ?? 'draft'){ 'active'=>'success','draft'=>'secondary','closed'=>'danger',default=>'secondary' }; @endphp
                                    <span class="badge bg-{{ $jsc }}-subtle text-{{ $jsc }}">{{ ucfirst($job->status ?? 'draft') }}</span>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        @endif

        @if(isset($results['companies']) && $results['companies']->count())
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h6 class="card-title mb-0 flex-grow-1"><i class="ri-building-line me-2 text-warning"></i>Companies</h6>
                <span class="badge bg-warning">{{ $results['companies']->count() }}</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Company</th>
                                <th>Location</th>
                                <th>Plan</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($results['companies'] as $company)
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-item avatar-xs avatar-title rounded bg-primary-subtle text-primary" style="font-size:10px;">{{ strtoupper(substr($company->name,0,2)) }}</div>
                                        <span class="fw-medium">{{ $company->name }}</span>
                                    </div>
                                </td>
                                <td class="text-muted">{{ $company->location ?? '—' }}</td>
                                <td><span class="badge bg-info-subtle text-info">{{ ucfirst($company->subscription_plan ?? 'free') }}</span></td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        @endif

        @if((!isset($results['users']) || !$results['users']->count()) && (!isset($results['jobs']) || !$results['jobs']->count()) && (!isset($results['companies']) || !$results['companies']->count()))
        <div class="card">
            <div class="card-body text-center py-5 text-muted">
                <i class="ri-search-line fs-1 d-block mb-2 opacity-50"></i>
                <h5>No results found for "{{ $q }}"</h5>
                <p class="mb-0">Try different keywords or check your spelling</p>
            </div>
        </div>
        @endif
    </div>

    <!-- Users Tab -->
    <div class="tab-pane" id="search-users" role="tabpanel">
        @if(isset($results['users']) && $results['users']->count())
        <div class="row g-3">
            @foreach($results['users'] as $user)
            <div class="col-md-6 col-lg-4">
                <div class="card card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="avatar-item avatar avatar-title rounded-circle text-white" style="background:var(--bs-primary);">{{ strtoupper(substr($user->name,0,1)) }}</div>
                        <div>
                            <h6 class="mb-0">{{ $user->name }}</h6>
                            <span class="text-muted fs-13">{{ $user->email }}</span>
                        </div>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <span class="badge bg-primary-subtle text-primary">{{ ucfirst($user->role->value ?? $user->role) }}</span>
                        <span class="text-muted fs-12">Joined {{ $user->created_at->format('M Y') }}</span>
                    </div>
                </div>
            </div>
            @endforeach
        </div>
        @else
        <div class="card card-body text-center text-muted py-4">No users found</div>
        @endif
    </div>

    <!-- Jobs Tab -->
    <div class="tab-pane" id="search-jobs" role="tabpanel">
        @if(isset($results['jobs']) && $results['jobs']->count())
        <div class="row g-3">
            @foreach($results['jobs'] as $job)
            <div class="col-md-6">
                <div class="card card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h6 class="mb-1">{{ $job->title }}</h6>
                            <p class="text-muted fs-13 mb-2">{{ $job->company?->name ?? 'Unknown' }} &bull; {{ $job->location ?? 'Remote' }}</p>
                        </div>
                        @php $jsc = match($job->status ?? 'draft'){ 'active'=>'success','draft'=>'secondary','closed'=>'danger',default=>'secondary' }; @endphp
                        <span class="badge bg-{{ $jsc }}-subtle text-{{ $jsc }}">{{ ucfirst($job->status ?? 'draft') }}</span>
                    </div>
                    <div class="d-flex gap-2 flex-wrap">
                        @if($job->experience_level)<span class="badge bg-light text-muted">{{ ucfirst($job->experience_level->value ?? $job->experience_level) }}</span>@endif
                        @if($job->job_type)<span class="badge bg-light text-muted">{{ ucfirst(str_replace('_',' ',$job->job_type->value ?? $job->job_type)) }}</span>@endif
                        @if($job->salary_min && $job->salary_max)<span class="badge bg-success-subtle text-success">${{ number_format($job->salary_min) }} - ${{ number_format($job->salary_max) }}</span>@endif
                    </div>
                </div>
            </div>
            @endforeach
        </div>
        @else
        <div class="card card-body text-center text-muted py-4">No jobs found</div>
        @endif
    </div>

    <!-- Companies Tab -->
    <div class="tab-pane" id="search-companies" role="tabpanel">
        @if(isset($results['companies']) && $results['companies']->count())
        <div class="row g-3">
            @foreach($results['companies'] as $company)
            <div class="col-md-6 col-lg-4">
                <div class="card card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="avatar-item avatar avatar-title rounded bg-primary-subtle text-primary">{{ strtoupper(substr($company->name,0,2)) }}</div>
                        <div>
                            <h6 class="mb-0">{{ $company->name }}</h6>
                            <span class="text-muted fs-13">{{ $company->location ?? 'Unknown location' }}</span>
                        </div>
                    </div>
                </div>
            </div>
            @endforeach
        </div>
        @else
        <div class="card card-body text-center text-muted py-4">No companies found</div>
        @endif
    </div>
</div>
@else
<div class="card">
    <div class="card-body text-center py-5">
        <i class="ri-search-line display-4 text-muted mb-3"></i>
        <h5>Search the Admin Panel</h5>
        <p class="text-muted">Find users, jobs, companies, and more</p>
    </div>
</div>
@endif
@endsection
