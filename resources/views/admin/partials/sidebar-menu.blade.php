<ul class="main-menu" id="all-menu-items" role="menu">

    <!-- ========================= MAIN ========================= -->
    <li class="menu-title" role="presentation">MAIN</li>
    <li class="slide">
        <a href="{{ route('admin.dashboard') }}" class="side-menu__item {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-dashboard-line"></i></span>
            <span class="side-menu__label">Dashboard</span>
        </a>
    </li>

    <!-- ========================= JOBS ========================= -->
    <li class="menu-title" role="presentation">JOBS</li>
    <li class="slide">
        <a href="{{ route('admin.jobs') }}" class="side-menu__item {{ request()->routeIs('admin.jobs*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-briefcase-4-line"></i></span>
            <span class="side-menu__label">Job Listings</span>
        </a>
    </li>
    <li class="slide">
        <a href="{{ route('admin.categories') }}" class="side-menu__item {{ request()->routeIs('admin.categories*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-folder-line"></i></span>
            <span class="side-menu__label">Categories</span>
        </a>
    </li>
    <li class="slide">
        <a href="{{ route('admin.applications') }}" class="side-menu__item {{ request()->routeIs('admin.applications*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-inbox-line"></i></span>
            <span class="side-menu__label">Applications</span>
            <span class="badge bg-warning rounded-pill ms-auto">{{ \App\Models\JobApplication::where('status', 'pending')->count() }}</span>
        </a>
    </li>

    <!-- ========================= USERS ========================= -->
    <li class="menu-title" role="presentation">USERS</li>
    <li class="slide">
        <a href="{{ route('admin.users') }}" class="side-menu__item {{ request()->routeIs('admin.users*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-group-line"></i></span>
            <span class="side-menu__label">All Users</span>
        </a>
    </li>
    <li class="slide">
        <a href="{{ route('admin.companies') }}" class="side-menu__item {{ request()->routeIs('admin.companies*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-building-2-line"></i></span>
            <span class="side-menu__label">Companies</span>
        </a>
    </li>

    <!-- ========================= FINANCE ========================= -->
    <li class="menu-title" role="presentation">FINANCE</li>
    <li class="slide">
        <a href="{{ route('admin.payments') }}" class="side-menu__item {{ request()->routeIs('admin.payments*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-bank-card-line"></i></span>
            <span class="side-menu__label">Payments</span>
        </a>
    </li>
    <li class="slide">
        <a href="{{ route('admin.subscriptions') }}" class="side-menu__item {{ request()->routeIs('admin.subscriptions*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-vip-crown-line"></i></span>
            <span class="side-menu__label">Subscriptions</span>
        </a>
    </li>

    <!-- ========================= PAGES ========================= -->
    <li class="menu-title" role="presentation">PAGES</li>
    <li class="slide">
        <a href="#!" class="side-menu__item" role="menuitem">
            <span class="side_menu_icon"><i class="ri-user-3-line"></i></span>
            <span class="side-menu__label">Profile</span>
            <i class="ri-arrow-down-s-line side-menu__angle"></i>
        </a>
        <ul class="slide-menu" role="menu">
            <li class="slide">
                <a href="{{ route('admin.profile') }}" class="side-menu__item {{ request()->routeIs('admin.profile') ? 'active' : '' }}" role="menuitem">Overview</a>
            </li>
            <li class="slide">
                <a href="{{ route('admin.profile.projects') }}" class="side-menu__item {{ request()->routeIs('admin.profile.projects') ? 'active' : '' }}" role="menuitem">Projects</a>
            </li>
            <li class="slide">
                <a href="{{ route('admin.profile.connections') }}" class="side-menu__item {{ request()->routeIs('admin.profile.connections') ? 'active' : '' }}" role="menuitem">Connections</a>
            </li>
        </ul>
    </li>
    <li class="slide">
        <a href="{{ route('admin.search') }}" class="side-menu__item {{ request()->routeIs('admin.search*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-search-line"></i></span>
            <span class="side-menu__label">Search</span>
        </a>
    </li>
    <li class="slide">
        <a href="{{ route('admin.faqs') }}" class="side-menu__item {{ request()->routeIs('admin.faqs*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-question-answer-line"></i></span>
            <span class="side-menu__label">FAQs</span>
        </a>
    </li>

    <!-- ========================= SYSTEM ========================= -->
    <li class="menu-title" role="presentation">SYSTEM</li>
    <li class="slide">
        <a href="{{ route('admin.settings') }}" class="side-menu__item {{ request()->routeIs('admin.settings*') ? 'active' : '' }}" role="menuitem">
            <span class="side_menu_icon"><i class="ri-settings-4-line"></i></span>
            <span class="side-menu__label">Settings</span>
        </a>
    </li>

</ul>
