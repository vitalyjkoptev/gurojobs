@extends('layouts.app')

@section('title', 'Sign In — GURO JOBS')
@section('description', 'Sign in to your GURO JOBS account. Access your iGaming career dashboard, saved jobs, and applications.')

@push('styles')
<style>
    .login-tabs {
        display: flex;
        border-radius: 12px;
        overflow: hidden;
        margin-bottom: 30px;
        background: #f0f2f5;
        padding: 4px;
    }
    .login-tab {
        flex: 1;
        text-align: center;
        padding: 12px 16px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        color: #666;
        border-radius: 10px;
        transition: all 0.3s;
        border: none;
        background: transparent;
    }
    .login-tab.active {
        background: #fff;
        color: var(--guro-primary, #015EA7);
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .login-tab:hover:not(.active) {
        color: #333;
        background: rgba(255,255,255,0.5);
    }
    .login-panel { display: none; }
    .login-panel.active { display: block; }

    .guro-login-card {
        background: #fff;
        border-radius: 16px;
        padding: 40px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.06);
        border: 1px solid #eee;
    }
    .guro-login-card .form-control {
        border-radius: 10px;
        padding: 12px 16px;
        border: 1px solid #ddd;
        font-size: 14px;
    }
    .guro-login-card .form-control:focus {
        border-color: var(--guro-primary, #015EA7);
        box-shadow: 0 0 0 3px rgba(1,94,167,0.1);
    }
    .btn-guro {
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 10px;
        font-weight: 700;
        font-size: 15px;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }
    .btn-admin {
        background: linear-gradient(135deg, #dc3545, #c82333);
        color: #fff;
    }
    .btn-admin:hover { background: linear-gradient(135deg, #c82333, #a71d2a); }
    .btn-employer {
        background: linear-gradient(135deg, var(--guro-primary, #015EA7), var(--guro-primary-dark, #014A85));
        color: #fff;
    }
    .btn-employer:hover { background: linear-gradient(135deg, #014A85, #013a6a); }
    .btn-candidate {
        background: linear-gradient(135deg, #28a745, #218838);
        color: #fff;
    }
    .btn-candidate:hover { background: linear-gradient(135deg, #218838, #1e7e34); }

    .btn-passkey {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 10px;
        background: #fafafa;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        color: #333;
        transition: all 0.3s;
    }
    .btn-passkey:hover { border-color: var(--guro-primary, #015EA7); background: #f0f7ff; }

    .btn-telegram {
        width: 100%;
        padding: 12px;
        border: none;
        border-radius: 10px;
        background: #0088cc;
        color: #fff;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        transition: all 0.3s;
    }
    .btn-telegram:hover { background: #006da3; }

    .divider {
        text-align: center;
        margin: 20px 0;
        position: relative;
        color: #999;
        font-size: 13px;
    }
    .divider::before, .divider::after {
        content: '';
        position: absolute;
        top: 50%;
        width: 40%;
        height: 1px;
        background: #e0e0e0;
    }
    .divider::before { left: 0; }
    .divider::after { right: 0; }

    .role-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 20px;
    }
    .role-badge.admin { background: #fde8ea; color: #dc3545; }
    .role-badge.employer { background: #e8f0fe; color: var(--guro-primary, #015EA7); }
    .role-badge.candidate { background: #e8f5e9; color: #28a745; }

    .quick-login-hint {
        background: #f8f9fa;
        border-radius: 10px;
        padding: 12px 16px;
        margin-bottom: 20px;
        font-size: 13px;
        color: #666;
        border-left: 3px solid;
    }
    .quick-login-hint.admin { border-color: #dc3545; }
    .quick-login-hint.employer { border-color: var(--guro-primary, #015EA7); }
    .quick-login-hint.candidate { border-color: #28a745; }

    .btn-skip-demo {
        width: 100%;
        padding: 12px;
        border: 2px dashed #ccc;
        border-radius: 10px;
        background: #fffbe6;
        color: #b8860b;
        font-weight: 700;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: all 0.3s;
        margin-top: 16px;
        text-decoration: none;
    }
    .btn-skip-demo:hover {
        background: #fff3cd;
        border-color: #b8860b;
        color: #8b6914;
    }
</style>
@endpush

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">Welcome Back</h1>
                    </div>
                    <p style="max-width: 500px; margin: 0 auto; color: #666;">Sign in to your GURO JOBS account to manage your iGaming career.</p>
                </div>
            </div>
        </div>
    </div>
    <!-- End Banner -->

    <!-- Login Form Section -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row d-flex align-items-center justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="guro-login-card">

                        <!-- Session Status / Errors -->
                        @if(session('status'))
                            <div class="alert alert-success mb-4" role="alert">
                                {{ session('status') }}
                            </div>
                        @endif

                        @if($errors->any())
                            <div class="alert alert-danger mb-4" role="alert">
                                @foreach($errors->all() as $error)
                                    <div>{{ $error }}</div>
                                @endforeach
                            </div>
                        @endif

                        <!-- Role Tabs -->
                        <div class="login-tabs">
                            <button class="login-tab active" data-role="admin" onclick="switchTab('admin')">
                                Admin
                            </button>
                            <button class="login-tab" data-role="employer" onclick="switchTab('employer')">
                                Employer
                            </button>
                            <button class="login-tab" data-role="candidate" onclick="switchTab('candidate')">
                                Candidate
                            </button>
                        </div>

                        <!-- ═══════ ADMIN Panel ═══════ -->
                        <div class="login-panel active" id="panel-admin">
                            <span class="role-badge admin">Admin Access</span>
                            <div class="quick-login-hint admin">
                                Admin panel access. Only authorized personnel.
                            </div>

                            <form method="POST" action="{{ route('login') }}">
                                @csrf
                                <input type="hidden" name="login_role" value="admin">
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Email</label>
                                    <input type="email" class="form-control" name="email" value="{{ old('email') }}" placeholder="admin@gurojobs.com" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Password</label>
                                    <input type="password" class="form-control" name="password" placeholder="Admin password" required>
                                </div>
                                <div class="mb-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="remember" id="remember-admin">
                                        <label class="form-check-label" for="remember-admin" style="font-size:14px;">Remember me</label>
                                    </div>
                                </div>
                                <button type="submit" class="btn-guro btn-admin">
                                    Sign In as Admin
                                </button>
                            </form>
                        </div>

                        <!-- ═══════ EMPLOYER Panel ═══════ -->
                        <div class="login-panel" id="panel-employer">
                            <span class="role-badge employer">Employer</span>
                            <div class="quick-login-hint employer">
                                Post iGaming jobs, manage applicants, and grow your team.
                            </div>

                            <!-- Passkey Login -->
                            <button type="button" class="btn-passkey mb-3" onclick="loginWithPasskey()">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2z"/><path d="M15 9a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/><path d="M6 19c0-3.314 2.686-6 6-6s6 2.686 6 6"/></svg>
                                Sign in with Passkey (FaceID)
                            </button>

                            <div class="divider">or with email</div>

                            <form method="POST" action="{{ route('login') }}">
                                @csrf
                                <input type="hidden" name="login_role" value="employer">
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Email</label>
                                    <input type="email" class="form-control" name="email" value="{{ old('email') }}" placeholder="employer@company.com" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Password</label>
                                    <input type="password" class="form-control" name="password" placeholder="Your password" required>
                                </div>
                                <div class="mb-4 d-flex justify-content-between align-items-center">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="remember" id="remember-employer">
                                        <label class="form-check-label" for="remember-employer" style="font-size:14px;">Remember me</label>
                                    </div>
                                    @if(Route::has('password.request'))
                                        <a href="{{ route('password.request') }}" style="font-size:13px;color:var(--guro-primary);text-decoration:none;">Forgot password?</a>
                                    @endif
                                </div>
                                <button type="submit" class="btn-guro btn-employer">
                                    Sign In as Employer
                                </button>
                            </form>

                            <div class="divider">or</div>

                            <button type="button" class="btn-telegram" onclick="loginWithTelegram()">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"/></svg>
                                Sign in with Telegram
                            </button>

                            <a href="{{ route('demo.login', ['role' => 'employer']) }}" class="btn-skip-demo">
                                Skip — Demo Employer Dashboard
                            </a>

                            <div class="text-center mt-4" style="font-size:14px;color:#666;">
                                Don't have an account?
                                <a href="{{ route('register') }}?role=employer" style="color:var(--guro-primary);font-weight:600;text-decoration:none;">Register as Employer</a>
                            </div>
                        </div>

                        <!-- ═══════ CANDIDATE Panel ═══════ -->
                        <div class="login-panel" id="panel-candidate">
                            <span class="role-badge candidate">Candidate</span>
                            <div class="quick-login-hint candidate">
                                Find your dream iGaming job. Apply, track, and manage your career.
                            </div>

                            <!-- Passkey Login -->
                            <button type="button" class="btn-passkey mb-3" onclick="loginWithPasskey()">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2z"/><path d="M15 9a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/><path d="M6 19c0-3.314 2.686-6 6-6s6 2.686 6 6"/></svg>
                                Sign in with Passkey (FaceID)
                            </button>

                            <div class="divider">or with email</div>

                            <form method="POST" action="{{ route('login') }}">
                                @csrf
                                <input type="hidden" name="login_role" value="candidate">
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Email</label>
                                    <input type="email" class="form-control" name="email" value="{{ old('email') }}" placeholder="your@email.com" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label" style="font-weight:600;font-size:14px;">Password</label>
                                    <input type="password" class="form-control" name="password" placeholder="Your password" required>
                                </div>
                                <div class="mb-4 d-flex justify-content-between align-items-center">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="remember" id="remember-candidate">
                                        <label class="form-check-label" for="remember-candidate" style="font-size:14px;">Remember me</label>
                                    </div>
                                    @if(Route::has('password.request'))
                                        <a href="{{ route('password.request') }}" style="font-size:13px;color:#28a745;text-decoration:none;">Forgot password?</a>
                                    @endif
                                </div>
                                <button type="submit" class="btn-guro btn-candidate">
                                    Sign In as Candidate
                                </button>
                            </form>

                            <div class="divider">or</div>

                            <button type="button" class="btn-telegram" onclick="loginWithTelegram()">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"/></svg>
                                Sign in with Telegram
                            </button>

                            <a href="{{ route('demo.login', ['role' => 'candidate']) }}" class="btn-skip-demo">
                                Skip — Demo Candidate Dashboard
                            </a>

                            <div class="text-center mt-4" style="font-size:14px;color:#666;">
                                Don't have an account?
                                <a href="{{ route('register') }}?role=candidate" style="color:#28a745;font-weight:600;text-decoration:none;">Register as Candidate</a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection

@push('scripts')
<script>
    function switchTab(role) {
        // Tabs
        document.querySelectorAll('.login-tab').forEach(function(t) { t.classList.remove('active'); });
        document.querySelector('.login-tab[data-role="'+role+'"]').classList.add('active');
        // Panels
        document.querySelectorAll('.login-panel').forEach(function(p) { p.classList.remove('active'); });
        document.getElementById('panel-'+role).classList.add('active');
    }

    // Auto-select tab from URL param
    var params = new URLSearchParams(window.location.search);
    if (params.get('role')) { switchTab(params.get('role')); }

    // Passkey (WebAuthn) login
    async function loginWithPasskey() {
        try {
            if (!window.PublicKeyCredential) {
                alert('Passkey login is not supported in this browser.');
                return;
            }
            var response = await fetch('/api/v1/auth/passkey/challenge', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content, 'Accept': 'application/json' }
            });
            if (!response.ok) throw new Error('Failed to get passkey challenge');
            var options = await response.json();
            options.challenge = Uint8Array.from(atob(options.challenge), function(c) { return c.charCodeAt(0); });
            if (options.allowCredentials) {
                options.allowCredentials = options.allowCredentials.map(function(cred) {
                    cred.id = Uint8Array.from(atob(cred.id), function(c) { return c.charCodeAt(0); });
                    return cred;
                });
            }
            var credential = await navigator.credentials.get({ publicKey: options });
            var verifyResponse = await fetch('/api/v1/auth/passkey/verify', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content, 'Accept': 'application/json' },
                body: JSON.stringify({
                    id: credential.id,
                    rawId: btoa(String.fromCharCode.apply(null, new Uint8Array(credential.rawId))),
                    response: {
                        authenticatorData: btoa(String.fromCharCode.apply(null, new Uint8Array(credential.response.authenticatorData))),
                        clientDataJSON: btoa(String.fromCharCode.apply(null, new Uint8Array(credential.response.clientDataJSON))),
                        signature: btoa(String.fromCharCode.apply(null, new Uint8Array(credential.response.signature))),
                    },
                    type: credential.type
                })
            });
            if (verifyResponse.ok) { window.location.href = '{{ route("home") }}'; }
            else { var err = await verifyResponse.json(); alert(err.message || 'Passkey verification failed.'); }
        } catch (error) {
            if (error.name !== 'NotAllowedError') { console.error('Passkey error:', error); alert('Passkey login failed.'); }
        }
    }

    // Telegram login
    function loginWithTelegram() {
        var w=550, h=470, l=(screen.width-w)/2, t=(screen.height-h)/2;
        window.open('/api/v1/auth/telegram/redirect', 'telegram_auth', 'width='+w+',height='+h+',left='+l+',top='+t+',toolbar=no,menubar=no');
    }
    window.addEventListener('message', function(e) {
        if (e.data && e.data.type === 'telegram_auth_success') { window.location.href = '{{ route("home") }}'; }
    });
</script>
@endpush
