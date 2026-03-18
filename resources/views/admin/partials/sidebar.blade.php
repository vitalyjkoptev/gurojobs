<!-- START SIDEBAR -->
<aside class="app-sidebar">
    <!-- START BRAND LOGO -->
    <div class="app-sidebar-logo px-6 justify-content-center align-items-center">
        <a href="{{ route('admin.dashboard') }}">
            <span class="app-sidebar-logo-default fw-bold fs-4" style="letter-spacing: 1px;">
                <span style="color: var(--bs-primary); font-weight: 800;">GURO</span><span style="color: #6c757d; font-weight: 300;">JOBS</span>
            </span>
            <span class="app-sidebar-logo-minimize fw-bold fs-5">
                <span style="color: var(--bs-primary); font-weight: 800;">G</span><span style="color: #6c757d; font-weight: 300;">J</span>
            </span>
        </a>
    </div>
    <!-- END BRAND LOGO -->
    <nav class="app-sidebar-menu nav nav-pills flex-column fs-6" id="sidebarMenu" aria-label="Main navigation">
        @include('admin.partials.sidebar-menu')
    </nav>
</aside>
<!-- END SIDEBAR -->
<div class="horizontal-overlay"></div>

<!-- START SMALL SCREEN SIDEBAR -->
<div class="offcanvas offcanvas-md offcanvas-start small-screen-sidebar" data-bs-scroll="true" tabindex="-1" id="smallScreenSidebar" aria-labelledby="smallScreenSidebarLabel">
    <div class="offcanvas-header hstack border-bottom">
        <div class="app-sidebar-logo">
            <a href="{{ route('admin.dashboard') }}">
                <span class="app-sidebar-logo-default fw-bold fs-4">
                    <span style="color: var(--bs-primary); font-weight: 800;">GURO</span><span style="color: #6c757d; font-weight: 300;">JOBS</span>
                </span>
            </a>
        </div>
        <button type="button" class="btn-close bg-transparent" data-bs-dismiss="offcanvas" aria-label="Close">
            <i class="ri-close-line"></i>
        </button>
    </div>
    <div class="offcanvas-body p-0">
        <aside class="app-sidebar">
            <nav class="app-sidebar-menu nav nav-pills flex-column fs-6" aria-label="Main navigation">
                @include('admin.partials.sidebar-menu')
            </nav>
        </aside>
    </div>
</div>
