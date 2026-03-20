@extends('layouts.app')

@section('title', 'Create Account — GURO JOBS')
@section('description', 'Create your free GURO JOBS account. Start your iGaming career journey today.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">Create Account</h1>
                    </div>
                    <p style="max-width: 500px; margin: 0 auto; color: #666;">Join GURO JOBS and start your iGaming career today.</p>
                </div>
            </div>
        </div>
    </div>
    <!-- End Banner -->

    <!-- Register Form -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row d-flex align-items-center justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="guro-login-card">

                        @if($errors->any())
                            <div class="alert alert-danger mb-4" role="alert">
                                @foreach($errors->all() as $error)
                                    <div>{{ $error }}</div>
                                @endforeach
                            </div>
                        @endif

                        <!-- Register with Passkey -->
                        <button type="button" class="btn-passkey mb-3" id="btn-passkey-register" onclick="registerWithPasskey()" style="background: #1a1a2e; color: #fff; border: none; padding: 12px 28px; border-radius: 8px; font-weight: 600; width: 100%; display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer; transition: all 0.3s;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2z"/>
                                <path d="M15 9a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                                <path d="M6 19c0-3.314 2.686-6 6-6s6 2.686 6 6"/>
                            </svg>
                            Register with Passkey (FaceID)
                        </button>

                        <div class="divider" style="display: flex; align-items: center; gap: 12px; color: #999; font-size: 13px; margin: 20px 0;">
                            <span style="flex: 1; height: 1px; background: #e0e0e0;"></span>
                            or register with email
                            <span style="flex: 1; height: 1px; background: #e0e0e0;"></span>
                        </div>

                        <form method="POST" action="{{ route('register') }}" id="register-form">
                            @csrf

                            <div class="mb-3">
                                <label for="name" class="form-label" style="font-weight: 600; font-size: 14px;">Full Name</label>
                                <input type="text" class="form-control @error('name') is-invalid @enderror"
                                       id="name" name="name" value="{{ old('name') }}"
                                       placeholder="John Doe" required autofocus>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label" style="font-weight: 600; font-size: 14px;">Email Address</label>
                                <input type="email" class="form-control @error('email') is-invalid @enderror"
                                       id="email" name="email" value="{{ old('email') }}"
                                       placeholder="your@email.com" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label" style="font-weight: 600; font-size: 14px;">Password</label>
                                <input type="password" class="form-control @error('password') is-invalid @enderror"
                                       id="password" name="password"
                                       placeholder="Min 8 characters" required>
                            </div>

                            <div class="mb-3">
                                <label for="password_confirmation" class="form-label" style="font-weight: 600; font-size: 14px;">Confirm Password</label>
                                <input type="password" class="form-control"
                                       id="password_confirmation" name="password_confirmation"
                                       placeholder="Repeat password" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" style="font-weight: 600; font-size: 14px;">I am a</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="role" id="role-candidate" value="candidate" checked>
                                        <label class="form-check-label" for="role-candidate">Candidate</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="role" id="role-employer" value="employer">
                                        <label class="form-check-label" for="role-employer">Employer</label>
                                    </div>
                                </div>
                            </div>

                            <!-- Communication Preferences -->
                            <div class="mb-3 mt-3" style="padding: 12px; background: #f8f9ff; border-radius: 10px;">
                                <label class="form-label" style="font-weight: 700; font-size: 14px; color: var(--guro-primary);">Communication Preferences</label>

                                <div class="mb-2">
                                    <label for="communication_language_priority" class="form-label" style="font-weight: 600; font-size: 13px;">Priority Language</label>
                                    <select class="form-select" id="communication_language_priority" name="communication_language_priority">
                                        <option value="">Select language...</option>
                                        @foreach(['English','German','Polish','Russian','Ukrainian','French','Spanish','Portuguese','Italian','Dutch','Swedish','Danish','Norwegian','Finnish','Greek','Czech','Romanian','Bulgarian','Croatian','Serbian','Hungarian','Turkish','Japanese','Korean','Chinese','Arabic','Hindi','Thai','Georgian','Hebrew','Vietnamese'] as $lang)
                                            <option value="{{ $lang }}">{{ $lang }}</option>
                                        @endforeach
                                    </select>
                                </div>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Acceptable Languages (up to 3)</label>
                                    <select class="form-select" id="comm_langs_acceptable" name="communication_languages_acceptable[]" multiple size="4">
                                        @foreach(['English','German','Polish','Russian','Ukrainian','French','Spanish','Portuguese','Italian','Dutch','Swedish','Danish','Norwegian','Finnish','Greek','Czech','Romanian','Bulgarian','Croatian','Serbian','Hungarian','Turkish'] as $lang)
                                            <option value="{{ $lang }}">{{ $lang }}</option>
                                        @endforeach
                                    </select>
                                    <div class="form-text">Hold Ctrl/Cmd to select multiple</div>
                                </div>
                            </div>

                            <!-- Candidate-specific filters -->
                            <div class="candidate-filters mb-3" style="padding: 12px; background: #f0faf5; border-radius: 10px; display: none;">
                                <label class="form-label" style="font-weight: 700; font-size: 14px; color: #28a745;">Country & Citizenship</label>

                                <div class="mb-2">
                                    <label for="citizenship_country" class="form-label" style="font-weight: 600; font-size: 13px;">Country of Citizenship</label>
                                    <select class="form-select" id="citizenship_country" name="citizenship_country">
                                        <option value="">Select country...</option>
                                    </select>
                                </div>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Are you in your citizenship country?</label>
                                    <div class="d-flex gap-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="in_citizenship_country" id="in_country_yes" value="1">
                                            <label class="form-check-label" for="in_country_yes">Yes</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="in_citizenship_country" id="in_country_no" value="0">
                                            <label class="form-check-label" for="in_country_no">No</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Block Company Countries</label>
                                    <select class="form-select" name="blocked_company_countries[]" multiple size="4">
                                    </select>
                                    <div class="form-text">Countries where you don't want to work</div>
                                </div>
                            </div>

                            <!-- Employer-specific filters -->
                            <div class="employer-filters mb-3" style="padding: 12px; background: #f0f5ff; border-radius: 10px; display: none;">
                                <label class="form-label" style="font-weight: 700; font-size: 14px; color: #015EA7;">Candidate Preferences</label>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Main Office Country</label>
                                    <select class="form-select" name="main_office_countries[]" multiple size="4">
                                    </select>
                                    <div class="form-text">Select one or more countries</div>
                                </div>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Block Candidate Citizenships</label>
                                    <select class="form-select" name="blocked_candidate_citizenships[]" multiple size="4">
                                    </select>
                                    <div class="form-text">Citizenships you can't offer jobs to</div>
                                </div>

                                <div class="mb-2">
                                    <label class="form-label" style="font-weight: 600; font-size: 13px;">Show Candidates</label>
                                    <div class="d-flex gap-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="candidate_location_pref" id="pref_all" value="all" checked>
                                            <label class="form-check-label" for="pref_all">All candidates</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="candidate_location_pref" id="pref_outside" value="outside">
                                            <label class="form-check-label" for="pref_outside">Outside citizenship country</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="terms" id="terms" required>
                                    <label class="form-check-label" for="terms" style="font-size: 13px;">
                                        I agree to the <a href="{{ route('terms') }}" target="_blank" style="color: var(--guro-primary);">Terms of Service</a> and <a href="{{ route('privacy') }}" target="_blank" style="color: var(--guro-primary);">Privacy Policy</a>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn-guro">Create Account</button>
                        </form>

                        <div class="text-center mt-4" style="font-size: 14px; color: #666;">
                            Already have an account?
                            <a href="{{ route('login') }}" style="color: var(--guro-primary); font-weight: 600; text-decoration: none;">Sign In</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection

@push('scripts')
<script>
    async function registerWithPasskey() {
        try {
            if (!window.PublicKeyCredential) {
                alert('Passkey is not supported in this browser.');
                return;
            }
            alert('Passkey registration will be available after the account is created. Please register with email first, then add a Passkey in your profile settings.');
        } catch (error) {
            console.error('Passkey error:', error);
        }
    }

    // Countries list for selects
    const countries = [
        'Albania','Andorra','Armenia','Austria','Azerbaijan','Belarus','Belgium','Bosnia and Herzegovina',
        'Brazil','Bulgaria','Canada','Chile','China','Colombia','Croatia','Curaçao','Cyprus','Czech Republic',
        'Denmark','Estonia','Finland','France','Georgia','Germany','Gibraltar','Greece','Hungary','Iceland',
        'India','Indonesia','Ireland','Isle of Man','Israel','Italy','Japan','Kazakhstan','Kenya','Kosovo',
        'Kyrgyzstan','Latvia','Lithuania','Luxembourg','Malaysia','Malta','Mexico','Moldova','Montenegro',
        'Netherlands','New Zealand','Nigeria','North Macedonia','Norway','Peru','Philippines','Poland','Portugal',
        'Romania','Russia','Serbia','Singapore','Slovakia','Slovenia','South Africa','South Korea','Spain',
        'Sweden','Switzerland','Tajikistan','Thailand','Turkey','Ukraine','United Arab Emirates','United Kingdom',
        'United States','Uzbekistan','Vietnam'
    ];

    // Populate all country selects
    document.querySelectorAll('select[name="citizenship_country"], select[name="blocked_company_countries[]"], select[name="main_office_countries[]"], select[name="blocked_candidate_citizenships[]"]').forEach(sel => {
        const hasPlaceholder = sel.name === 'citizenship_country';
        countries.forEach(c => {
            const opt = document.createElement('option');
            opt.value = c; opt.textContent = c;
            sel.appendChild(opt);
        });
    });

    // Toggle role-specific filters
    document.querySelectorAll('input[name="role"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.querySelector('.candidate-filters').style.display = this.value === 'candidate' ? 'block' : 'none';
            document.querySelector('.employer-filters').style.display = this.value === 'employer' ? 'block' : 'none';
        });
    });

    // Show candidate filters by default (candidate is checked)
    document.querySelector('.candidate-filters').style.display = 'block';
</script>
@endpush
