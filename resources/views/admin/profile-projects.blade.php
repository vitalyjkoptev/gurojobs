@extends('admin.partials.layouts.master')

@section('title', 'Projects — GURO JOBS Admin')
@section('pagetitle', 'Pages')
@section('sub-title', 'Profile Projects')

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
            <li class="nav-item"><a class="nav-link active" href="{{ route('admin.profile.projects') }}">Projects</a></li>
            <li class="nav-item"><a class="nav-link" href="{{ route('admin.profile.connections') }}">Connections</a></li>
        </ul>
    </div>
</div>

<div class="row g-3">
    @php
        $projects = [
            ['name' => 'GURO JOBS Website', 'desc' => 'Main job portal website with iGaming focus', 'status' => 'Active', 'color' => 'success', 'icon' => 'ri-global-line', 'progress' => 85],
            ['name' => 'Mobile App (Flutter)', 'desc' => 'iOS & Android app for candidates and employers', 'status' => 'In Progress', 'color' => 'warning', 'icon' => 'ri-smartphone-line', 'progress' => 65],
            ['name' => 'Admin Dashboard', 'desc' => 'Herozi-based admin panel for platform management', 'status' => 'Active', 'color' => 'success', 'icon' => 'ri-dashboard-line', 'progress' => 90],
            ['name' => 'Jarvis AI Assistant', 'desc' => 'Claude-powered voice assistant with Web Speech API', 'status' => 'Beta', 'color' => 'info', 'icon' => 'ri-robot-line', 'progress' => 40],
            ['name' => 'Payment System', 'desc' => 'Stripe + NOWPayments crypto integration', 'status' => 'Active', 'color' => 'success', 'icon' => 'ri-bank-card-line', 'progress' => 95],
            ['name' => 'Telegram Bot', 'desc' => 'Job alerts and auth via Telegram integration', 'status' => 'In Progress', 'color' => 'warning', 'icon' => 'ri-telegram-line', 'progress' => 50],
            ['name' => 'CV Builder', 'desc' => 'iGaming-specific CV builder for candidates', 'status' => 'Planned', 'color' => 'secondary', 'icon' => 'ri-file-text-line', 'progress' => 15],
            ['name' => 'API v1', 'desc' => 'REST API for mobile app and integrations', 'status' => 'Active', 'color' => 'success', 'icon' => 'ri-code-s-slash-line', 'progress' => 80],
        ];
    @endphp

    @foreach($projects as $project)
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body">
                <div class="d-flex align-items-start justify-content-between mb-3">
                    <div class="avatar-item avatar-sm avatar-title bg-{{ $project['color'] }}-subtle text-{{ $project['color'] }} rounded-2">
                        <i class="{{ $project['icon'] }} fs-18"></i>
                    </div>
                    <span class="badge bg-{{ $project['color'] }}-subtle text-{{ $project['color'] }}">{{ $project['status'] }}</span>
                </div>
                <h6 class="fw-semibold mb-1">{{ $project['name'] }}</h6>
                <p class="text-muted fs-12 mb-3">{{ $project['desc'] }}</p>
                <div class="progress" style="height: 4px;">
                    <div class="progress-bar bg-{{ $project['color'] }}" style="width: {{ $project['progress'] }}%"></div>
                </div>
                <span class="text-muted fs-12 mt-1">{{ $project['progress'] }}% Complete</span>
            </div>
        </div>
    </div>
    @endforeach
</div>
@endsection
