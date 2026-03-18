<header class="app-header">
  <div class="container-fluid">
    <div class="nav-header">

      <div class="header-left hstack gap-3">
        <div class="app-sidebar-logo app-horizontal-logo justify-content-center align-items-center">
          <a href="{{ route('admin.dashboard') }}">
            <span style="font-size: 20px; font-weight: 800; color: var(--bs-primary); letter-spacing: 1px;">GURO</span>
            <span style="font-size: 20px; font-weight: 300; color: #666;">ADMIN</span>
          </a>
        </div>

        <button type="button" class="btn btn-light-light icon-btn sidebar-toggle d-none d-md-block" aria-expanded="false" aria-controls="main-menu">
          <i class="ri-menu-2-fill"></i>
        </button>

        <button class="btn btn-light-light icon-btn d-md-none small-screen-toggle" id="smallScreenSidebarLabel" type="button" data-bs-toggle="offcanvas" data-bs-target="#smallScreenSidebar" aria-controls="smallScreenSidebar">
          <i class="ri-arrow-right-fill"></i>
        </button>
      </div>

      <div class="header-right hstack gap-3">
        <div class="hstack gap-0 gap-sm-1">

          <!-- Theme -->
          <div class="dropdown features-dropdown d-none d-sm-block">
            <button type="button" class="btn icon-btn btn-text-primary rounded-circle" data-bs-toggle="dropdown" aria-expanded="false">
              <i class="ri-sun-line fs-20"></i>
            </button>
            <div class="dropdown-menu dropdown-menu-end">
              <div class="dropdown-item cursor-pointer" id="light-theme">
                <span class="hstack gap-2"><i class="ri-sun-line"></i>Light</span>
              </div>
              <div class="dropdown-item cursor-pointer" id="dark-theme">
                <span class="hstack gap-2"><i class="ri-moon-clear-line"></i>Dark</span>
              </div>
            </div>
          </div>

          <!-- Notification -->
          <div class="dropdown features-dropdown">
            <button type="button" class="btn icon-btn btn-text-primary rounded-circle position-relative" data-bs-toggle="dropdown" aria-expanded="false">
              <i class="ri-notification-2-line fs-20"></i>
              <span class="position-absolute translate-middle badge rounded-pill p-1 min-w-20px badge text-bg-danger">0</span>
            </button>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0">
              <div class="dropdown-header d-flex align-items-center py-3">
                <h6 class="mb-0 me-auto">Notifications</h6>
              </div>
              <div class="p-4 text-center text-muted">
                <i class="ri-notification-off-line fs-1 d-block mb-2"></i>
                No new notifications
              </div>
            </div>
          </div>

          <!-- Fullscreen -->
          <button type="button" id="fullscreen-button" class="btn icon-btn btn-text-primary rounded-circle d-none d-sm-block" aria-pressed="false">
            <i class="ri-fullscreen-line fs-16"></i>
          </button>

          <!-- Back to Site -->
          <a href="{{ route('home') }}" class="btn icon-btn btn-text-primary rounded-circle" title="Back to site">
            <i class="ri-external-link-line fs-16"></i>
          </a>
        </div>

        <!-- Profile -->
        <div class="dropdown profile-dropdown features-dropdown">
          <button type="button" class="btn profile-btn shadow-none px-0 hstack gap-0 gap-sm-3" data-bs-toggle="dropdown" aria-expanded="false">
            <span class="position-relative">
              <span class="avatar-item avatar overflow-hidden">
                @if(auth()->user()->avatar)
                  <img class="img-fluid" src="{{ asset('storage/' . auth()->user()->avatar) }}" alt="">
                @else
                  <div class="avatar-item avatar avatar-title text-white" style="background: var(--bs-primary);">
                    {{ strtoupper(substr(auth()->user()->name, 0, 1)) }}
                  </div>
                @endif
              </span>
              <span class="position-absolute border-2 border border-white h-12px w-12px rounded-circle bg-success end-0 bottom-0"></span>
            </span>
            <span>
              <span class="h6 d-none d-xl-inline-block text-start fw-semibold mb-0">{{ auth()->user()->name }}</span>
              <span class="d-none d-xl-block fs-12 text-start text-muted">{{ ucfirst(auth()->user()->role->value) }}</span>
            </span>
          </button>

          <div class="dropdown-menu dropdown-menu-end">
            <a class="dropdown-item" href="{{ route('dashboard') }}">
              <i class="ri-dashboard-line me-2"></i>Dashboard
            </a>
            <div class="dropdown-divider"></div>
            <form method="POST" action="{{ route('logout') }}">
              @csrf
              <button type="submit" class="dropdown-item text-danger">
                <i class="ri-logout-box-line me-2"></i>Sign out
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>
