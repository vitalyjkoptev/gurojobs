@extends('admin.partials.layouts.master')

@section('title', 'Profile — GURO JOBS Admin')
@section('pagetitle', 'Pages')
@section('sub-title', 'Profile Overview')

@section('content')

<div class="card">
    <div class="card-body pb-0">
        <!-- Profile Header -->
        <div class="d-flex flex-column flex-md-row align-items-center gap-4 mb-4">
            <div class="position-relative">
                @if($user->avatar)
                    <img src="{{ asset('storage/' . $user->avatar) }}" class="avatar-xxl rounded-circle" alt="{{ $user->name }}">
                @else
                    <div class="avatar-xxl rounded-circle d-flex align-items-center justify-content-center text-white fs-1 fw-bold" style="background: var(--bs-primary); width: 96px; height: 96px;">
                        {{ strtoupper(substr($user->name, 0, 1)) }}
                    </div>
                @endif
                <span class="position-absolute border-2 border border-white h-16px w-16px rounded-circle bg-success end-0 bottom-0"></span>
            </div>
            <div class="text-center text-md-start flex-grow-1">
                <h4 class="mb-1">{{ $user->name }}</h4>
                <p class="text-muted mb-2">{{ ucfirst($user->role->value ?? $user->role) }} &bull; {{ $user->email }}</p>
                <div class="d-flex gap-2 justify-content-center justify-content-md-start flex-wrap">
                    @if($user->telegram_id)<span class="badge bg-info-subtle text-info"><i class="ri-telegram-line me-1"></i>Telegram Connected</span>@endif
                    @if($user->is_verified ?? false)<span class="badge bg-success-subtle text-success"><i class="ri-shield-check-line me-1"></i>Verified</span>@endif
                    <span class="badge bg-primary-subtle text-primary"><i class="ri-calendar-line me-1"></i>Joined {{ $user->created_at->format('M Y') }}</span>
                </div>
            </div>
            <div class="hstack gap-2">
                <a href="{{ route('admin.settings') }}" class="btn btn-primary btn-sm"><i class="ri-settings-3-line me-1"></i>Edit Profile</a>
            </div>
        </div>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs-bordered border-0 justify-content-center mt-3" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link active" href="{{ route('admin.profile') }}">Overview</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" href="{{ route('admin.profile.projects') }}">Projects</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" href="{{ route('admin.profile.connections') }}">Connections</a>
            </li>
        </ul>
    </div>
</div>

<div class="row g-4">
    <div class="col-md-4">
        <!-- Personal Info -->
        <div class="card card-body mb-3">
            <h5>Personal Information</h5>
            <p class="text-muted fs-13 mb-3">Admin profile details for the GURO JOBS platform.</p>
            <ul class="list-unstyled mb-0">
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-user-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Full Name</b> : {{ $user->name }}
                </li>
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-mail-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Email</b> : {{ $user->email }}
                </li>
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-phone-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Phone</b> : {{ $user->phone ?? 'Not set' }}
                </li>
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-shield-user-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Role</b> : {{ ucfirst($user->role->value ?? $user->role) }}
                </li>
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-calendar-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Registered</b> : {{ $user->created_at->format('M d, Y') }}
                </li>
                @if($user->telegram_id)
                <li class="fs-13 text-muted hstack flex-wrap mb-2">
                    <i class="ri-telegram-line me-2 text-light fs-18 align-middle"></i>
                    <b class="fw-semibold text-body">Telegram</b> : {{ $user->telegram_id }}
                </li>
                @endif
            </ul>
        </div>

        <!-- Platform Stats -->
        <div class="card card-body">
            <h5 class="mb-3">Platform Stats</h5>
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="avatar-item avatar-sm avatar-title bg-primary-subtle text-primary rounded-2"><i class="ri-group-line"></i></div>
                <div>
                    <h6 class="mb-0">{{ \App\Models\User::count() }}</h6>
                    <span class="text-muted fs-12">Total Users</span>
                </div>
            </div>
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="avatar-item avatar-sm avatar-title bg-success-subtle text-success rounded-2"><i class="ri-briefcase-line"></i></div>
                <div>
                    <h6 class="mb-0">{{ \App\Models\Job::where('status','active')->count() }}</h6>
                    <span class="text-muted fs-12">Active Jobs</span>
                </div>
            </div>
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="avatar-item avatar-sm avatar-title bg-warning-subtle text-warning rounded-2"><i class="ri-building-line"></i></div>
                <div>
                    <h6 class="mb-0">{{ \App\Models\Company::count() }}</h6>
                    <span class="text-muted fs-12">Companies</span>
                </div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="avatar-item avatar-sm avatar-title bg-info-subtle text-info rounded-2"><i class="ri-file-list-3-line"></i></div>
                <div>
                    <h6 class="mb-0">{{ \App\Models\JobApplication::count() }}</h6>
                    <span class="text-muted fs-12">Applications</span>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-8">
        <!-- About -->
        <div class="card card-body mb-3">
            <h5 class="mb-3">About</h5>
            <p class="fs-13 text-muted">Administrator of the GURO JOBS iGaming job portal. Managing job listings, employer accounts, candidate applications, and platform settings. Overseeing subscriptions, payments, and user management for the global iGaming recruitment platform.</p>
        </div>

        <!-- Recent Activity -->
        <div class="card card-body">
            <h5 class="mb-4">Recent Activity</h5>
            <ul class="timeline-box mb-0">
                @php
                    $recentUsers = \App\Models\User::latest()->take(3)->get();
                    $recentJobs = \App\Models\Job::with('company')->latest()->take(3)->get();
                @endphp

                @foreach($recentUsers as $ru)
                <li class="timeline-section">
                    <div class="position-relative timeline-icon h-max">
                        <div class="border-0 text-bg-primary avatar-item avatar">{{ strtoupper(substr($ru->name,0,2)) }}</div>
                    </div>
                    <div class="timeline-content p-0">
                        <div class="d-flex flex-column gap-1">
                            <h6 class="mb-0 fw-medium">{{ $ru->name }}</h6>
                            <p class="mb-0 text-muted fs-12">{{ $ru->created_at->diffForHumans() }}</p>
                        </div>
                        <div class="mt-1 d-inline-flex flex-wrap align-items-center gap-2 text-muted">
                            <span>New {{ $ru->role->value ?? 'user' }} registered</span>
                            <span class="badge bg-primary-subtle text-primary">{{ $ru->email }}</span>
                        </div>
                    </div>
                </li>
                @endforeach

                @foreach($recentJobs as $rj)
                <li class="timeline-section">
                    <div class="position-relative timeline-icon h-max">
                        <div class="border-0 text-bg-success avatar-item avatar"><i class="ri-briefcase-line"></i></div>
                    </div>
                    <div class="timeline-content p-0">
                        <div class="d-flex flex-column gap-1">
                            <h6 class="mb-0 fw-medium">{{ $rj->title }}</h6>
                            <p class="mb-0 text-muted fs-12">{{ $rj->created_at->diffForHumans() }}</p>
                        </div>
                        <div class="mt-1 d-inline-flex flex-wrap align-items-center gap-2 text-muted">
                            <span>Posted by {{ $rj->company?->name ?? 'Unknown' }}</span>
                            <span class="badge bg-success-subtle text-success">{{ $rj->location ?? 'Remote' }}</span>
                        </div>
                    </div>
                </li>
                @endforeach
            </ul>
        </div>
    </div>
</div>
@endsection
