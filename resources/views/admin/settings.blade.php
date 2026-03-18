@extends('admin.partials.layouts.master')

@section('title', 'Settings — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Settings')

@section('content')

<div class="row">
    <!-- Settings Nav -->
    <div class="col-xl-3">
        <div class="card">
            <div class="card-body p-3">
                <div class="nav flex-column nav-pills" id="settingsTab" role="tablist">
                    <button class="nav-link active text-start" data-bs-toggle="pill" data-bs-target="#tab-general"><i class="ri-settings-3-line me-2"></i>General</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-branding"><i class="ri-palette-line me-2"></i>Branding</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-payments"><i class="ri-bank-card-line me-2"></i>Payments</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-jarvis"><i class="ri-robot-line me-2"></i>Jarvis AI</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-telegram"><i class="ri-telegram-line me-2"></i>Telegram</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-email"><i class="ri-mail-line me-2"></i>Email & SMTP</button>
                    <button class="nav-link text-start" data-bs-toggle="pill" data-bs-target="#tab-seo"><i class="ri-search-eye-line me-2"></i>SEO</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Settings Content -->
    <div class="col-xl-9">
        <div class="tab-content">

            <!-- General -->
            <div class="tab-pane fade show active" id="tab-general">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0">General Settings</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">Site Name</label><input type="text" class="form-control" value="GURO JOBS"></div>
                                <div class="col-md-6"><label class="form-label">Site URL</label><input type="url" class="form-control" value="https://gurojobs.com"></div>
                            </div>
                            <div class="mb-3"><label class="form-label">Site Description</label><textarea class="form-control" rows="2">iGaming Job Portal — Find Your Dream Job in iGaming Industry</textarea></div>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Contact Email</label><input type="email" class="form-control" value="info@gurojobs.com"></div>
                                <div class="col-md-4"><label class="form-label">Support Email</label><input type="email" class="form-control" value="support@gurojobs.com"></div>
                                <div class="col-md-4"><label class="form-label">Phone</label><input type="text" class="form-control" value=""></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Default Language</label>
                                    <select class="form-select"><option value="en" selected>English</option><option value="ru">Russian</option></select>
                                </div>
                                <div class="col-md-4"><label class="form-label">Default Currency</label>
                                    <select class="form-select"><option value="USD" selected>USD</option><option value="EUR">EUR</option><option value="GBP">GBP</option></select>
                                </div>
                                <div class="col-md-4"><label class="form-label">Timezone</label>
                                    <select class="form-select"><option>UTC</option><option selected>Europe/Warsaw</option><option>Europe/London</option></select>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="maintenance" ><label class="form-check-label" for="maintenance">Maintenance Mode</label></div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="registration" checked><label class="form-check-label" for="registration">User Registration Enabled</label></div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save Changes</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Branding -->
            <div class="tab-pane fade" id="tab-branding">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0">Branding</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label">Logo</label>
                                    <div class="border rounded p-3 text-center">
                                        <span style="font-size:24px;font-weight:800;color:#015EA7;">GURO</span>
                                        <span style="font-size:24px;font-weight:300;color:#666;">JOBS</span>
                                        <div class="mt-2"><input type="file" class="form-control form-control-sm" accept="image/*"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Favicon</label>
                                    <div class="border rounded p-3 text-center">
                                        <img src="{{ asset('images/favicon.png') }}" width="48" height="48" alt="favicon" class="mb-2" onerror="this.style.display='none'">
                                        <div><input type="file" class="form-control form-control-sm" accept="image/*"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Primary Color</label><input type="color" class="form-control form-control-color w-100" value="#015EA7"></div>
                                <div class="col-md-4"><label class="form-label">Secondary Color</label><input type="color" class="form-control form-control-color w-100" value="#666666"></div>
                                <div class="col-md-4"><label class="form-label">Accent Color</label><input type="color" class="form-control form-control-color w-100" value="#00C851"></div>
                            </div>
                            <div class="mb-3"><label class="form-label">Social Links</label>
                                <div class="row g-2">
                                    <div class="col-md-4"><div class="input-group"><span class="input-group-text"><i class="ri-linkedin-box-line"></i></span><input type="url" class="form-control" placeholder="LinkedIn URL"></div></div>
                                    <div class="col-md-4"><div class="input-group"><span class="input-group-text"><i class="ri-twitter-x-line"></i></span><input type="url" class="form-control" placeholder="X/Twitter URL"></div></div>
                                    <div class="col-md-4"><div class="input-group"><span class="input-group-text"><i class="ri-telegram-line"></i></span><input type="url" class="form-control" placeholder="Telegram Channel"></div></div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save Branding</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Payments -->
            <div class="tab-pane fade" id="tab-payments">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0">Payment Settings</h5></div>
                    <div class="card-body">
                        <form>
                            <h6 class="text-muted mb-3"><i class="ri-bank-card-line me-1"></i>Stripe</h6>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">Publishable Key</label><input type="text" class="form-control" placeholder="pk_live_..." value="{{ config('services.stripe.key') }}"></div>
                                <div class="col-md-6"><label class="form-label">Secret Key</label><input type="password" class="form-control" placeholder="sk_live_..." value=""></div>
                            </div>
                            <div class="mb-4"><label class="form-label">Webhook Secret</label><input type="password" class="form-control" placeholder="whsec_..."></div>

                            <hr>
                            <h6 class="text-muted mb-3"><i class="ri-bit-coin-line me-1"></i>NOWPayments (Crypto)</h6>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">API Key</label><input type="password" class="form-control" placeholder="NOW Payments API Key"></div>
                                <div class="col-md-6"><label class="form-label">IPN Secret</label><input type="password" class="form-control" placeholder="IPN Secret"></div>
                            </div>

                            <hr>
                            <h6 class="text-muted mb-3">Payment Options</h6>
                            <div class="row mb-3">
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked id="stripeEnabled"><label class="form-check-label" for="stripeEnabled">Stripe Enabled</label></div></div>
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="cryptoEnabled"><label class="form-check-label" for="cryptoEnabled">Crypto Enabled</label></div></div>
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked id="applePayEnabled"><label class="form-check-label" for="applePayEnabled">Apple Pay</label></div></div>
                            </div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save Payments</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Jarvis AI -->
            <div class="tab-pane fade" id="tab-jarvis">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0"><i class="ri-robot-line me-2"></i>Jarvis AI Master Agent</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="row mb-3">
                                <div class="col-md-6"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked id="jarvisEnabled"><label class="form-check-label" for="jarvisEnabled">Jarvis Enabled</label></div></div>
                                <div class="col-md-6"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" checked id="jarvisAI"><label class="form-check-label" for="jarvisAI">AI Mode (Claude)</label></div></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">AI Model</label>
                                    <select class="form-select"><option value="claude-sonnet-4-6" selected>Claude Sonnet 4.6</option><option value="claude-opus-4">Claude Opus 4</option></select>
                                </div>
                                <div class="col-md-6"><label class="form-label">API Key (Anthropic)</label><input type="password" class="form-control" placeholder="sk-ant-..."></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Max History</label><input type="number" class="form-control" value="50"></div>
                                <div class="col-md-4"><label class="form-label">Voice Language</label>
                                    <select class="form-select"><option value="en-US" selected>English</option><option value="ru-RU">Russian</option></select>
                                </div>
                                <div class="col-md-4"><label class="form-label">Shortcut</label><input type="text" class="form-control" value="Ctrl+J" readonly></div>
                            </div>
                            <div class="alert alert-info mb-3">
                                <i class="ri-information-line me-1"></i>
                                Jarvis AI is available only to Admin and Employer roles. All commands are logged in <code>jarvis_logs</code> table.
                            </div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save Jarvis Settings</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Telegram -->
            <div class="tab-pane fade" id="tab-telegram">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0"><i class="ri-telegram-line me-2"></i>Telegram Integration</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="mb-3"><label class="form-label">Bot Token</label><input type="password" class="form-control" placeholder="123456:ABC-DEF..."></div>
                            <div class="mb-3"><label class="form-label">Webhook URL</label><input type="url" class="form-control" placeholder="https://gurojobs.com/api/v1/telegram/webhook"></div>
                            <div class="mb-3"><label class="form-label">Community Channels (comma separated)</label><input type="text" class="form-control" placeholder="@gurojobs, @igaming_jobs"></div>
                            <div class="row mb-3">
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="tgAutoPost"><label class="form-check-label" for="tgAutoPost">Auto-post new jobs</label></div></div>
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="tgImport"><label class="form-check-label" for="tgImport">Import from channels</label></div></div>
                                <div class="col-md-4"><div class="form-check form-switch"><input class="form-check-input" type="checkbox" id="tgNotify"><label class="form-check-label" for="tgNotify">Notifications</label></div></div>
                            </div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save Telegram</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Email -->
            <div class="tab-pane fade" id="tab-email">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0"><i class="ri-mail-line me-2"></i>Email & SMTP</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Mail Driver</label>
                                    <select class="form-select"><option value="smtp" selected>SMTP</option><option value="mailgun">Mailgun</option><option value="ses">Amazon SES</option><option value="log">Log (Dev)</option></select>
                                </div>
                                <div class="col-md-4"><label class="form-label">SMTP Host</label><input type="text" class="form-control" placeholder="smtp.gmail.com"></div>
                                <div class="col-md-4"><label class="form-label">SMTP Port</label><input type="number" class="form-control" value="587"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4"><label class="form-label">Username</label><input type="text" class="form-control" placeholder="user@gmail.com"></div>
                                <div class="col-md-4"><label class="form-label">Password</label><input type="password" class="form-control"></div>
                                <div class="col-md-4"><label class="form-label">Encryption</label>
                                    <select class="form-select"><option value="tls" selected>TLS</option><option value="ssl">SSL</option><option value="">None</option></select>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">From Name</label><input type="text" class="form-control" value="GURO JOBS"></div>
                                <div class="col-md-6"><label class="form-label">From Email</label><input type="email" class="form-control" value="noreply@gurojobs.com"></div>
                            </div>
                            <button type="button" class="btn btn-primary me-2"><i class="ri-save-line me-1"></i>Save Email Settings</button>
                            <button type="button" class="btn btn-outline-info"><i class="ri-mail-send-line me-1"></i>Send Test Email</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- SEO -->
            <div class="tab-pane fade" id="tab-seo">
                <div class="card">
                    <div class="card-header"><h5 class="card-title mb-0"><i class="ri-search-eye-line me-2"></i>SEO Settings</h5></div>
                    <div class="card-body">
                        <form>
                            <div class="mb-3"><label class="form-label">Meta Title</label><input type="text" class="form-control" value="GURO JOBS — iGaming Job Portal"></div>
                            <div class="mb-3"><label class="form-label">Meta Description</label><textarea class="form-control" rows="2">Find your dream job in iGaming. Thousands of verified positions from top casino, sportsbook and gambling companies worldwide.</textarea></div>
                            <div class="mb-3"><label class="form-label">Meta Keywords</label><input type="text" class="form-control" value="igaming jobs, casino jobs, gambling careers, sportsbook jobs"></div>
                            <div class="row mb-3">
                                <div class="col-md-6"><label class="form-label">OG Image</label><input type="file" class="form-control" accept="image/*"></div>
                                <div class="col-md-6"><label class="form-label">Google Analytics ID</label><input type="text" class="form-control" placeholder="G-XXXXXXXXXX"></div>
                            </div>
                            <div class="mb-3"><label class="form-label">robots.txt</label><textarea class="form-control font-monospace fs-13" rows="4">User-agent: *
Allow: /
Sitemap: https://gurojobs.com/sitemap.xml</textarea></div>
                            <button type="button" class="btn btn-primary"><i class="ri-save-line me-1"></i>Save SEO</button>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
@endsection
