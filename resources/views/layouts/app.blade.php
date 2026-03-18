<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="keywords" content="@yield('keywords', 'iGaming jobs, casino careers, betting jobs, eSports jobs, game development careers')">
    <meta name="description" content="@yield('description', 'GURO JOBS — the leading job portal for the iGaming industry. Casino, Betting, eSports, Game Development and more.')">
    <meta property="og:site_name" content="GURO JOBS">
    <meta property="og:url" content="{{ url()->current() }}">
    <meta property="og:type" content="website">
    <meta property="og:title" content="@yield('title', 'GURO JOBS — iGaming Jobs Portal')">
    <meta name="og:image" content="{{ asset('images/og-image.png') }}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#015EA7">
    <meta name="msapplication-navbutton-color" content="#015EA7">
    <meta name="apple-mobile-web-app-status-bar-style" content="#015EA7">

    <title>@yield('title', 'GURO JOBS — iGaming Jobs Portal')</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="{{ asset('images/favicon.png') }}">
    <!-- Main style sheet (KHUJ) -->
    <link rel="stylesheet" type="text/css" href="{{ asset('css/style.css') }}" media="all">
    <!-- Responsive style sheet (KHUJ) -->
    <link rel="stylesheet" type="text/css" href="{{ asset('css/responsive.css') }}" media="all">

    <!-- GURO JOBS overrides -->
    <style>
        :root {
            --guro-primary: #015EA7;
            --guro-primary-dark: #014A85;
            --guro-primary-light: #0277BD;
            --guro-accent: #00BCD4;
            --guro-success: #4CAF50;
            --guro-warning: #FFC107;
            --guro-danger: #FF5722;
            --guro-bg: #F5F7FA;
            --guro-text: #333333;
            --guro-text-secondary: #666666;
        }

        /* ===== GLOBAL: Override ALL KHUJ green to GURO blue ===== */
        /* Nav links */
        .navbar-nav .nav-link.active,
        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-item .nav-link.active,
        .navbar-nav .nav-item .nav-link:hover,
        .theme-main-menu .navbar-nav .nav-link.active,
        .theme-main-menu .navbar-nav .nav-link:hover {
            color: var(--guro-primary) !important;
        }
        .navbar-nav .nav-link.active::after,
        .navbar-nav .nav-link:hover::after,
        .navbar-nav .nav-link.active::before,
        .navbar-nav .nav-link:hover::before {
            background: var(--guro-primary) !important;
            background-color: var(--guro-primary) !important;
            border-color: var(--guro-primary) !important;
        }
        /* Job cards hover & borders */
        .job-1:hover,
        .job-list-1:hover,
        .recent-job-item:hover .job-1 {
            border-color: var(--guro-primary) !important;
        }
        .job-1 a:hover,
        .job-list-1 a:hover,
        .job-title h3 a:hover,
        .job-sallary a,
        .job-apply a,
        .left-2 a,
        a:hover {
            color: var(--guro-primary) !important;
        }
        /* Sign up button */
        .right-wiget .sign-up .custom-btn,
        .right-wiget .sign-up a {
            background: var(--guro-primary) !important;
        }
        .right-wiget .sign-up .custom-btn:hover,
        .right-wiget .sign-up a:hover {
            background: var(--guro-primary-dark) !important;
        }
        /* Pagination, links */
        .pagination .page-item.active .page-link,
        .pagination .page-link:hover {
            background: var(--guro-primary) !important;
            border-color: var(--guro-primary) !important;
        }
        /* Category hover — override ALL green */
        .job-category-one:hover {
            border-color: var(--guro-primary) !important;
            background: rgba(1, 94, 167, 0.04) !important;
        }
        .job-category-one:hover a,
        .job-category-one:hover span,
        .job-category-one:hover p,
        .job-category-one:hover h4,
        .job-category-one:hover .job-icon-one,
        .job-category-one:hover .category-link {
            color: var(--guro-primary) !important;
        }
        .job-category-one:hover .job-icon-one {
            background: rgba(1, 94, 167, 0.15) !important;
        }
        .job-category-one:hover .job-icon-one svg path,
        .job-category-one:hover .job-icon-one i {
            fill: var(--guro-primary) !important;
            color: var(--guro-primary) !important;
            stroke: var(--guro-primary) !important;
        }
        /* Subscribe/newsletter button */
        .subscribe-one .custom_btn,
        .subscriber-content-right .custom_btn {
            background: var(--guro-primary) !important;
        }
        /* CTA section button */
        .customer_rapper .custom-btn,
        .customer_rapper .custom_btn {
            background: #fff !important;
            color: var(--guro-primary) !important;
        }
        /* Scroll top */
        .scroll-top {
            background: var(--guro-primary) !important;
        }
        /* Social links hover */
        .social_group ul li a:hover {
            background: var(--guro-primary) !important;
        }
        /* All remaining overrides */
        .custom-btn,
        .btn-custom,
        .custom_btn {
            background: var(--guro-primary) !important;
            border-color: var(--guro-primary) !important;
        }
        .custom-btn:hover,
        .btn-custom:hover,
        .custom_btn:hover {
            background: var(--guro-primary-dark) !important;
            border-color: var(--guro-primary-dark) !important;
        }

        .banner-one .left_banner h1 span,
        .heading span,
        .heading-2 span,
        .why-choose-us .choose-us-heading h2 span {
            color: var(--guro-primary) !important;
        }

        .span-one {
            color: var(--guro-primary) !important;
        }

        .job-category-one.active {
            background: var(--guro-primary) !important;
        }

        .job-icon-one {
            background: rgba(1, 94, 167, 0.1) !important;
        }

        .category-link {
            color: var(--guro-primary) !important;
        }

        .job-1 .job-sallary a,
        .job-apply a {
            background: var(--guro-primary) !important;
            color: #fff !important;
        }
        .job-1 .job-sallary a:hover,
        .job-apply a:hover {
            background: var(--guro-primary-dark) !important;
        }

        .feature-job-rapper {
            background: var(--guro-bg) !important;
        }

        .footer-one {
            background: var(--guro-primary) !important;
        }
        /* ALL footer text/links white */
        .footer-one,
        .footer-one *,
        .footer-one h4,
        .footer-one h5,
        .footer-one p,
        .footer-one a,
        .footer-one li,
        .footer-one li a,
        .footer-one span,
        .footer-one i,
        .footer-one .footer-one_1,
        .footer-one .footer-one_1 p,
        .footer-one .footer-one_2 h4,
        .footer-one .footer-one_2 ul li a,
        .footer-one .copy-right h5,
        .footer-one .guro-brand-text,
        .footer-one .guro-brand-text .brand-light,
        .footer-one .social_group ul li a,
        .footer-one .social_group ul li a i {
            color: #fff !important;
        }
        .footer-one a:hover {
            color: rgba(255,255,255,0.8) !important;
        }
        /* Social icons in footer — white bg transparent, white icons */
        .footer-one .social_group ul li a {
            background: rgba(255,255,255,0.15) !important;
            border-color: rgba(255,255,255,0.3) !important;
        }
        .footer-one .social_group ul li a:hover {
            background: rgba(255,255,255,0.3) !important;
        }
        /* Footer columns centering */
        .footer-one .footer-one_2 ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .footer-one .footer-one_2 ul li {
            padding: 4px 0;
        }
        .footer-one .footer-one_2 ul li a {
            text-decoration: none;
            font-size: 15px;
            transition: opacity 0.2s;
        }
        .footer-one .footer-one_2 ul li a:hover {
            opacity: 0.8;
        }
        .footer-one .footer-one_2 h4 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 16px !important;
        }
        .footer-one .copy-right {
            border-top: 1px solid rgba(255,255,255,0.2);
            margin-top: 40px;
        }

        .Customer-one .customer_rapper {
            background: var(--guro-primary) !important;
        }
        .Customer-one .customer_rapper h2,
        .Customer-one .customer_rapper p {
            color: #fff !important;
        }

        .subscribe-one .subscriber-content-right .custom_btn {
            background: var(--guro-primary) !important;
        }

        /* Experience level badges */
        .badge-level {
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-c-level { background: #FFF8E1; color: #F9A825; }
        .badge-head { background: #F3E5F5; color: #9C27B0; }
        .badge-senior { background: #E3F2FD; color: #015EA7; }
        .badge-middle { background: #E8F5E9; color: #4CAF50; }
        .badge-junior { background: #E1F5FE; color: #03A9F4; }

        /* Work mode badges */
        .badge-remote { background: #E8F5E9; color: #2E7D32; }
        .badge-hybrid { background: #FFF3E0; color: #EF6C00; }
        .badge-onsite { background: #E3F2FD; color: #1565C0; }

        /* Search Highlight */
        mark {
            background: #FFF176;
            padding: 0 2px;
            border-radius: 2px;
        }

        /* Experience Level Pills */
        .level-pills { display: flex; gap: 8px; flex-wrap: wrap; }
        .level-pill {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            color: var(--guro-text);
            background: #fff;
        }
        .level-pill:hover, .level-pill.active {
            background: var(--guro-primary);
            color: #fff;
            border-color: var(--guro-primary);
        }

        /* Scroll to top override */
        .scroll-top {
            background: var(--guro-primary) !important;
        }

        /* GURO brand text in nav */
        .guro-brand-text {
            font-size: 24px;
            font-weight: 800;
            color: var(--guro-primary);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .guro-brand-text .brand-light {
            font-weight: 300;
            color: var(--guro-text);
        }

        /* Login form styles */
        .guro-login-card {
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            max-width: 460px;
            margin: 0 auto;
        }
        .guro-login-card .form-control {
            padding: 12px 16px;
            border-radius: 8px;
            border: 1px solid #ddd;
            font-size: 15px;
        }
        .guro-login-card .form-control:focus {
            border-color: var(--guro-primary);
            box-shadow: 0 0 0 3px rgba(1,94,167,0.1);
        }
        .guro-login-card .btn-guro {
            background: var(--guro-primary);
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
        }
        .guro-login-card .btn-guro:hover {
            background: var(--guro-primary-dark);
        }
        .guro-login-card .btn-passkey {
            background: #1a1a2e;
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .guro-login-card .btn-passkey:hover {
            background: #0f0f1a;
        }
        .guro-login-card .btn-telegram {
            background: #0088cc;
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .guro-login-card .btn-telegram:hover {
            background: #006da3;
        }
        .guro-login-card .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #999;
            font-size: 13px;
            margin: 20px 0;
        }
        .guro-login-card .divider::before,
        .guro-login-card .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e0e0e0;
        }
    </style>

    @stack('styles')
</head>

<body>
    <div class="main-page-wrapper">
        <!-- Loading Transition -->
        <div id="preloader">
            <div id="khoj-preloader" class="khoj-preloader">
                <div class="animation-preloader">
                    <h1>GURO</h1>
                </div>
            </div>
        </div>

        <!-- Header -->
        <div class="theme-main-menu sticky-menu theme-menu-one">
            <div class="inner-content">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex logo order-lg-0">
                        <a href="{{ route('home') }}" class="d-block guro-brand-text">
                            GURO <span class="brand-light">JOBS</span>
                        </a>
                    </div>
                    <div class="right-wiget d-lg-flex align-items-center order-lg-3">
                        @auth
                            <div class="people">
                                <a href="{{ route('dashboard') }}"><img src="{{ asset('images/icon/user.svg') }}" alt="Dashboard"></a>
                            </div>
                            <div class="sign-up">
                                <a class="custom-btn" href="{{ route('dashboard') }}">{{ auth()->user()->name }}</a>
                            </div>
                        @else
                            <div class="people">
                                <a href="{{ route('login') }}"><img src="{{ asset('images/icon/user.svg') }}" alt="Sign In"></a>
                            </div>
                            <div class="sign-up">
                                <a class="custom-btn" href="{{ route('register') }}">Create Account</a>
                            </div>
                        @endauth
                    </div>

                    <!-- Nav -->
                    <div class="left-wiget">
                        <nav class="navbar navbar-expand-lg order-lg-2">
                            <button class="navbar-toggler d-block d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                                <span></span>
                            </button>
                            <div class="collapse navbar-collapse" id="navbarNav">
                                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('home') ? 'active' : '' }}" href="{{ route('home') }}">Home</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('jobs.*') ? 'active' : '' }}" href="{{ route('jobs.index') }}">Find a Job</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('for-employers') ? 'active' : '' }}" href="{{ route('for-employers') }}">For Employers</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('about') ? 'active' : '' }}" href="{{ route('about') }}">About</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('contact') ? 'active' : '' }}" href="{{ route('contact') }}">Contact</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link {{ request()->routeIs('app.download') ? 'active' : '' }}" href="{{ route('app.download') }}">
                                            App
                                        </a>
                                    </li>
                                </ul>
                                <div class="right-wiget d-flex align-items-center order-lg-3 d-lg-none">
                                    @auth
                                        <div class="people"><a href="{{ route('dashboard') }}"><img src="{{ asset('images/icon/user.svg') }}" alt=""></a></div>
                                        <div class="sign-up"><a class="custom-btn" href="{{ route('dashboard') }}">{{ auth()->user()->name }}</a></div>
                                    @else
                                        <div class="people"><a href="{{ route('login') }}"><img src="{{ asset('images/icon/user.svg') }}" alt=""></a></div>
                                        <div class="sign-up"><a class="custom-btn" href="{{ route('register') }}">Create Account</a></div>
                                    @endauth
                                </div>
                            </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Header -->

        <!-- Main Content -->
        @yield('content')

        <!-- Newsletter (hide on dashboard) -->
        @unless(request()->routeIs('dashboard') || request()->routeIs('admin.*'))
        <section class="subscribe-one pb-80">
            <div class="container">
                <div class="row g-5 d-flex align-items-center">
                    <div class="col-lg-6">
                        <div class="subscriber-content-left">
                            <h2>Subscribe to Our<br> Newsletter</h2>
                        </div>
                    </div>
                    <div class="col-lg-6 ms-auto">
                        <div class="subscriber-content-right">
                            <form action="#" method="POST">
                                @csrf
                                <input type="email" name="email" placeholder="Your Email Address" required>
                                <button type="submit" class="custom_btn ms-auto">SUBSCRIBE</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        @endunless

        <!-- Footer -->
        <div class="footer-one pt-80 pb-80">
            <div class="container">
                <div class="row d-flex align-items-start">
                    <div class="col-lg-8 col-xl-8">
                        <div class="row">
                            <div class="col-lg-8 col-xl-8">
                                <div class="footer-one_1">
                                    <a href="{{ route('home') }}" class="d-block pb-30 guro-brand-text" style="color: #fff;">
                                        GURO <span class="brand-light" style="color: rgba(255,255,255,0.7);">JOBS</span>
                                    </a>
                                    <p>The leading job portal for the iGaming industry. Find your dream career in Casino, Betting, eSports, Game Development and more.</p>
                                    <div class="social_group pt-40">
                                        <ul>
                                            <li><a href="#"><i class="bi bi-telegram"></i></a></li>
                                            <li><a href="#"><i class="bi bi-linkedin"></i></a></li>
                                            <li><a href="#"><i class="bi bi-twitter"></i></a></li>
                                            <li><a href="#"><i class="bi bi-instagram"></i></a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xl-4 ms-auto">
                                <div class="footer-one_2">
                                    <h4 class="mb-10 md-mt-30">For Candidates</h4>
                                    <ul>
                                        <li><a href="{{ route('jobs.index') }}">Find a Job</a></li>
                                        <li><a href="{{ route('cv-builder') }}">CV Builder</a></li>
                                        <li><a href="{{ route('register') }}">Create Profile</a></li>
                                        <li><a href="{{ route('for-employers') }}">For Employers</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 col-xl-4">
                        <div class="row">
                            <div class="col-lg-6 col-xl-6">
                                <div class="footer-one_2">
                                    <h4 class="mb-10 md-mt-30">Company</h4>
                                    <ul>
                                        <li><a href="{{ route('about') }}">About Us</a></li>
                                        <li><a href="{{ route('contact') }}">Contact</a></li>
                                        <li><a href="{{ route('privacy') }}">Privacy Policy</a></li>
                                        <li><a href="{{ route('terms') }}">Terms of Service</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-lg-6 col-xl-6">
                                <div class="footer-one_2">
                                    <h4 class="mb-10 md-mt-30">Tools</h4>
                                    <ul>
                                        <li><a href="{{ route('cv-builder') }}">CV Builder</a></li>
                                        <li><a href="{{ route('app.download') }}"><i class="bi bi-phone me-1"></i>Download App</a></li>
                                        <li><a href="https://t.me/GuroJobs" target="_blank" rel="noopener"><i class="bi bi-telegram me-1"></i>Telegram</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="copy-right text-center pt-60">
                        <h5>&copy; {{ date('Y') }} GURO JOBS. All rights reserved.</h5>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Footer -->

        <button class="scroll-top">
            <i class="bi bi-arrow-up-short"></i>
        </button>

    <!-- jQuery -->
    <script src="{{ asset('vendor/jquery.min.js') }}"></script>
    <!-- Bootstrap JS -->
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <!-- AOS js -->
    <script src="{{ asset('vendor/aos-next/dist/aos.js') }}"></script>
    <!-- Slick Slider -->
    <script src="{{ asset('vendor/slick/slick.min.js') }}"></script>
    <!-- js Counter -->
    <script src="{{ asset('vendor/jquery.counterup.min.js') }}"></script>
    <script src="{{ asset('vendor/jquery.waypoints.min.js') }}"></script>
    <!-- Nice Select -->
    <script src="{{ asset('vendor/nice-select/jquery.nice-select.min.js') }}"></script>
    <!-- Theme js -->
    <script src="{{ asset('js/theme.js') }}"></script>

    @include('components.jarvis-widget')

    @stack('scripts')

    </div> {{-- /.main-page-wrapper --}}
</body>
</html>
