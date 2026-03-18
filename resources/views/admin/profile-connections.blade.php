@extends('admin.partials.layouts.master')

@section('title', 'Connections — GURO JOBS Admin')
@section('pagetitle', 'Pages')
@section('sub-title', 'Profile Connections')

@section('content')

<div class="card">
    <div class="card-body pb-0">
        <div class="d-flex flex-column flex-md-row align-items-center gap-4 mb-4">
            <div class="position-relative">
                <div class="avatar-xxl rounded-circle d-flex align-items-center justify-content-center text-white fs-1 fw-bold" style="background: var(--bs-primary); width: 96px; height: 96px;">
                    {{ strtoupper(substr($user->name, 0, 1)) }}
                </div>
            </div>
            <div class="text-center text-md-start flex-grow-1">
                <h4 class="mb-1">{{ $user->name }}</h4>
                <p class="text-muted mb-0">{{ ucfirst($user->role->value ?? $user->role) }} &bull; {{ $user->email }}</p>
            </div>
        </div>
        <ul class="nav nav-tabs-bordered border-0 justify-content-center mt-3" role="tablist">
            <li class="nav-item"><a class="nav-link" href="{{ route('admin.profile') }}">Overview</a></li>
            <li class="nav-item"><a class="nav-link" href="{{ route('admin.profile.projects') }}">Projects</a></li>
            <li class="nav-item"><a class="nav-link active" href="{{ route('admin.profile.connections') }}">Connections</a></li>
        </ul>
    </div>
</div>

<!-- Filter -->
<div class="card mb-3">
    <div class="card-body py-2">
        <div class="row align-items-center">
            <div class="col">
                <h6 class="mb-0">{{ $users->count() }} Team Members</h6>
            </div>
            <div class="col-auto">
                <div class="d-flex gap-2">
                    <div class="form-icon">
                        <i class="ri-search-line text-muted"></i>
                        <input type="search" class="form-control form-control-sm form-control-icon" placeholder="Search members..." id="searchConnections">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-3" id="connectionsList">
    @foreach($users as $member)
    <div class="col-xl-3 col-md-4 col-sm-6 connection-card">
        <div class="card card-h-100">
            <div class="card-body text-center">
                <div class="dropdown float-end">
                    <button class="btn btn-sm btn-subtle-secondary p-1" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#"><i class="ri-eye-line me-2"></i>View Profile</a></li>
                        <li><a class="dropdown-item" href="#"><i class="ri-mail-line me-2"></i>Send Email</a></li>
                    </ul>
                </div>

                <div class="mb-3">
                    @if($member->avatar)
                        <img src="{{ asset('storage/' . $member->avatar) }}" class="avatar-lg rounded-circle" alt="">
                    @else
                        @php
                            $colors = ['primary','success','info','warning','danger'];
                            $color = $colors[$member->id % count($colors)];
                        @endphp
                        <div class="avatar-lg rounded-circle d-inline-flex align-items-center justify-content-center text-white fw-bold fs-4" style="background: var(--bs-{{ $color }}); width: 64px; height: 64px;">
                            {{ strtoupper(substr($member->name, 0, 1)) }}
                        </div>
                    @endif
                </div>

                <h6 class="fw-semibold mb-1 member-name">{{ $member->name }}</h6>
                <p class="text-muted fs-12 mb-2">{{ $member->email }}</p>

                <div class="d-flex justify-content-center gap-1 mb-3">
                    @php
                        $rc = match($member->role->value ?? $member->role){
                            'admin'=>'danger','employer'=>'primary','candidate'=>'success',default=>'secondary'
                        };
                    @endphp
                    <span class="badge bg-{{ $rc }}-subtle text-{{ $rc }}">{{ ucfirst($member->role->value ?? $member->role) }}</span>
                    @if($member->telegram_id)
                        <span class="badge bg-info-subtle text-info"><i class="ri-telegram-line"></i></span>
                    @endif
                </div>

                <p class="text-muted fs-12 mb-0">
                    <i class="ri-calendar-line me-1"></i>Joined {{ $member->created_at->format('M d, Y') }}
                </p>
            </div>
        </div>
    </div>
    @endforeach
</div>

@if($users->isEmpty())
<div class="card">
    <div class="card-body text-center py-5 text-muted">
        <i class="ri-team-line fs-1 d-block mb-2 opacity-50"></i>
        No team members found
    </div>
</div>
@endif
@endsection

@section('js')
<script>
document.getElementById('searchConnections')?.addEventListener('input', function() {
    const q = this.value.toLowerCase();
    document.querySelectorAll('.connection-card').forEach(card => {
        const name = card.querySelector('.member-name')?.textContent?.toLowerCase() || '';
        card.style.display = name.includes(q) ? '' : 'none';
    });
});
</script>
@endsection
