@extends('layouts.app')

@section('title', 'Finish setup — GURO JOBS')

@section('content')

    <section class="mb-160 md-mb-80 mt-120 md-mt-80">
        <div class="container">
            <div class="row d-flex align-items-center justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="guro-login-card">

                        <h2 class="mb-2">Almost there, {{ $user->name }}</h2>
                        <p class="mb-4 text-muted">
                            You signed in with Telegram. Tell us a bit more to finish creating your account.
                        </p>

                        @if ($errors->any())
                            <div class="alert alert-danger mb-4" role="alert">
                                @foreach ($errors->all() as $error)
                                    <div>{{ $error }}</div>
                                @endforeach
                            </div>
                        @endif

                        <form method="POST" action="{{ route('onboarding.store') }}">
                            @csrf

                            <div class="mb-3">
                                <label class="form-label">I am a…</label>
                                <div class="d-flex gap-3">
                                    <label class="form-check flex-grow-1 border rounded p-3">
                                        <input class="form-check-input me-2" type="radio" name="role" value="candidate"
                                               {{ old('role', 'candidate') === 'candidate' ? 'checked' : '' }}>
                                        Candidate
                                    </label>
                                    <label class="form-check flex-grow-1 border rounded p-3">
                                        <input class="form-check-input me-2" type="radio" name="role" value="employer"
                                               {{ old('role') === 'employer' ? 'checked' : '' }}>
                                        Employer
                                    </label>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="email">Email</label>
                                <input id="email" name="email" type="email" required
                                       class="form-control" value="{{ old('email') }}"
                                       placeholder="you@example.com">
                                <small class="text-muted">We'll send a verification link here.</small>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="password">
                                    Password <span class="text-muted">(optional — Telegram is enough)</span>
                                </label>
                                <input id="password" name="password" type="password" minlength="8"
                                       class="form-control" placeholder="At least 8 characters">
                            </div>

                            <div class="mb-4">
                                <label class="form-label" for="password_confirmation">Repeat password</label>
                                <input id="password_confirmation" name="password_confirmation" type="password"
                                       minlength="8" class="form-control">
                            </div>

                            <button type="submit" class="btn btn-primary w-100">Continue</button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
