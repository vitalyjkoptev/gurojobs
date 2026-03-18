<!DOCTYPE html>
<html lang="en" class="h-100">

<head>
    <meta charset="utf-8">
    <title>@yield('title', 'GURO JOBS — Admin Panel')</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="GURO JOBS Admin Panel — iGaming Job Portal Management">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <link rel="shortcut icon" href="{{ asset('images/favicon.png') }}">

    @include('admin.partials.datatable-css')
    @yield('css')
    @include('admin.partials.head-css')

    <style>
        :root,
        [data-bs-theme="light"],
        [data-layout-mode="light"] {
            --bs-primary: #015EA7 !important;
            --bs-primary-rgb: 1,94,167 !important;
            --bs-primary-text-emphasis: #014A85;
            --bs-primary-bg-subtle: #cce0f1;
            --bs-primary-border-subtle: #99c1e3;
            --bs-link-color: #015EA7;
            --bs-link-color-rgb: 1,94,167;
            --bs-link-hover-color: #014A85;
        }
        .btn-primary, .btn-primary:hover, .btn-primary:focus, .btn-primary:active,
        .btn-primary:disabled {
            background-color: #015EA7 !important;
            border-color: #015EA7 !important;
        }
        .btn-primary:hover { background-color: #014A85 !important; border-color: #014A85 !important; }
        .bg-primary { background-color: #015EA7 !important; }
        .text-primary { color: #015EA7 !important; }
        .border-primary { border-color: #015EA7 !important; }
        a { color: #015EA7; }
        a:hover { color: #014A85; }
        .nav-link.active, .page-link.active, .active > .page-link {
            background-color: #015EA7 !important;
            border-color: #015EA7 !important;
        }
        .form-check-input:checked {
            background-color: #015EA7;
            border-color: #015EA7;
        }
    </style>
</head>

<body>

    @include('admin.partials.header')
    @include('admin.partials.sidebar')

    <main class="app-wrapper">
        <div class="app-container">
            @include('admin.partials.breadcrumb')
            @yield('content')
            @include('admin.partials.bottom-wrapper')
            @include('admin.partials.datatable-script')
            @yield('js')
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.querySelector('.app-sidebar');
            if (sidebar && document.documentElement.getAttribute('data-bs-theme') === 'dark') {
                sidebar.classList.add('sidebar-dark');
            }
        });
    </script>

</body>
</html>
