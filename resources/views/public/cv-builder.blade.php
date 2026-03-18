@extends('layouts.app')

@section('title', 'iGaming CV Builder — GURO JOBS')
@section('description', 'Create a professional iGaming CV. Tailored for Casino, Betting, eSports and Game Development professionals.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">iGaming CV Builder</h1>
                    </div>
                    <p style="max-width: 600px; margin: 0 auto; color: #666;">Create a professional CV tailored for the iGaming industry. Stand out to top employers.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- CV Form -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row d-flex justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5" style="background: #fff; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.06);">

                        <form id="cv-form">
                            <!-- Personal Info -->
                            <h4 class="mb-20" style="color: var(--guro-primary);"><i class="bi bi-person-circle me-2"></i>Personal Information</h4>
                            <div class="row g-3 mb-40">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Full Name *</label>
                                    <input type="text" class="form-control" id="cv-name" placeholder="John Doe" required
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Email *</label>
                                    <input type="email" class="form-control" id="cv-email" placeholder="your@email.com" required
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Phone</label>
                                    <input type="tel" class="form-control" id="cv-phone" placeholder="+356 9999 0000"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Location</label>
                                    <input type="text" class="form-control" id="cv-location" placeholder="Malta / Remote"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">LinkedIn</label>
                                    <input type="url" class="form-control" id="cv-linkedin" placeholder="https://linkedin.com/in/..."
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Portfolio / Website</label>
                                    <input type="url" class="form-control" id="cv-website" placeholder="https://..."
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                            </div>

                            <!-- Professional Profile -->
                            <h4 class="mb-20" style="color: var(--guro-primary);"><i class="bi bi-briefcase me-2"></i>Professional Profile</h4>
                            <div class="row g-3 mb-40">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Desired Position *</label>
                                    <input type="text" class="form-control" id="cv-position" placeholder="e.g. Senior Slot Developer"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Experience Level *</label>
                                    <select class="form-select" id="cv-level" style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                        <option value="">Select...</option>
                                        <option value="C-Level">C-Level (CEO, CTO, CMO...)</option>
                                        <option value="Head">Head of Department</option>
                                        <option value="Senior">Senior (5+ years)</option>
                                        <option value="Middle">Middle (2-5 years)</option>
                                        <option value="Junior">Junior (0-2 years)</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">iGaming Sector</label>
                                    <select class="form-select" id="cv-sector" style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                        <option value="">Select...</option>
                                        <option value="Gambling">Gambling</option>
                                        <option value="Betting">Betting</option>
                                        <option value="Crypto">Crypto</option>
                                        <option value="Dating">Dating</option>
                                        <option value="E-Commerce">E-Commerce</option>
                                        <option value="FinTech">FinTech</option>
                                        <option value="Nutra">Nutra</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Work Mode Preference</label>
                                    <select class="form-select" id="cv-workmode" style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                        <option value="Remote">Remote</option>
                                        <option value="Hybrid">Hybrid</option>
                                        <option value="On-site">On-site</option>
                                        <option value="Any">Any</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Professional Summary *</label>
                                    <textarea class="form-control" id="cv-summary" rows="4"
                                              placeholder="Brief overview of your iGaming experience, key achievements, and what you bring to the table..."
                                              style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;"></textarea>
                                </div>
                            </div>

                            <!-- Skills -->
                            <h4 class="mb-20" style="color: var(--guro-primary);"><i class="bi bi-tools me-2"></i>Skills & Technologies</h4>
                            <div class="row g-3 mb-40">
                                <div class="col-12">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Key Skills (comma-separated)</label>
                                    <input type="text" class="form-control" id="cv-skills"
                                           placeholder="e.g. HTML5 Slots, Unity, C++, Game Math, RTP Analysis, Regulatory Compliance"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Languages</label>
                                    <input type="text" class="form-control" id="cv-languages"
                                           placeholder="e.g. English (Native), German (B2), Maltese (A1)"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Certifications & Licenses</label>
                                    <input type="text" class="form-control" id="cv-certs"
                                           placeholder="e.g. MGA Personal License, GDPR Certified, Responsible Gaming Certificate"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                            </div>

                            <!-- Experience -->
                            <h4 class="mb-20" style="color: var(--guro-primary);"><i class="bi bi-building me-2"></i>Work Experience</h4>
                            <div id="experience-entries">
                                <div class="experience-entry p-4 mb-20" style="background: var(--guro-bg); border-radius: 12px;">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold" style="font-size: 14px;">Company</label>
                                            <input type="text" class="form-control exp-company" placeholder="e.g. Evolution Gaming"
                                                   style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold" style="font-size: 14px;">Position</label>
                                            <input type="text" class="form-control exp-position" placeholder="e.g. Senior Game Developer"
                                                   style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold" style="font-size: 14px;">From</label>
                                            <input type="month" class="form-control exp-from" style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold" style="font-size: 14px;">To</label>
                                            <input type="month" class="form-control exp-to" style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold" style="font-size: 14px;">Location</label>
                                            <input type="text" class="form-control exp-location" placeholder="Malta"
                                                   style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;">
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label fw-bold" style="font-size: 14px;">Key Responsibilities & Achievements</label>
                                            <textarea class="form-control exp-desc" rows="3"
                                                      placeholder="Describe your key responsibilities and achievements in this role..."
                                                      style="padding: 10px 14px; border-radius: 8px; border: 1px solid #ddd;"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-outline-primary mb-40" onclick="addExperience()" style="border-color: var(--guro-primary); color: var(--guro-primary);">
                                <i class="bi bi-plus-lg me-1"></i> Add Experience
                            </button>

                            <!-- Education -->
                            <h4 class="mb-20" style="color: var(--guro-primary);"><i class="bi bi-mortarboard me-2"></i>Education</h4>
                            <div class="row g-3 mb-40">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">University / School</label>
                                    <input type="text" class="form-control" id="cv-university" placeholder="University of Malta"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Degree & Field</label>
                                    <input type="text" class="form-control" id="cv-degree" placeholder="BSc Computer Science"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Year From</label>
                                    <input type="number" class="form-control" id="cv-edu-from" placeholder="2018" min="1990" max="2030"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold" style="font-size: 14px;">Year To</label>
                                    <input type="number" class="form-control" id="cv-edu-to" placeholder="2022" min="1990" max="2030"
                                           style="padding: 12px 16px; border-radius: 8px; border: 1px solid #ddd;">
                                </div>
                            </div>

                            <!-- Generate Button -->
                            <div class="text-center">
                                <button type="button" class="custom-btn" onclick="generateCV()" style="border: none; padding: 16px 60px; cursor: pointer; font-size: 16px;">
                                    <i class="bi bi-file-earmark-pdf me-2"></i>Generate CV
                                </button>
                                <p class="mt-15" style="color: #999; font-size: 13px;">Your CV will be generated as a downloadable PDF</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection

@push('scripts')
<script>
    function addExperience() {
        var entry = document.querySelector('.experience-entry').cloneNode(true);
        entry.querySelectorAll('input, textarea').forEach(function(el) { el.value = ''; });
        document.getElementById('experience-entries').appendChild(entry);
    }

    function generateCV() {
        var name = document.getElementById('cv-name').value;
        if (!name) {
            alert('Please fill in at least your name to generate a CV.');
            return;
        }
        alert('CV generation will be available soon. Your data has been saved to your profile.');
    }
</script>
@endpush
