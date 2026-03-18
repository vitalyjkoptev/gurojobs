@extends('admin.partials.layouts.master')

@section('title', 'Companies — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Companies')
@section('buttonTitle', '+ Add Company')
@section('modalTarget', 'addCompanyModal')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-building-2-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Companies</p><h4 class="mb-0 fw-semibold">{{ $companies->total() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-verified-badge-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Verified</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Company::where('verified', true)->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-warning-subtle text-warning rounded-2"><i class="ri-vip-crown-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">With Active Plan</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Company::whereNotNull('plan')->where('plan', '!=', 'free')->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-info-subtle text-info rounded-2"><i class="ri-briefcase-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Active Jobs</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Job::active()->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search company..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="verified" class="form-select form-select-sm">
                    <option value="">All</option>
                    <option value="1" {{ request('verified')==='1'?'selected':'' }}>Verified</option>
                    <option value="0" {{ request('verified')==='0'?'selected':'' }}>Unverified</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="plan" class="form-select form-select-sm">
                    <option value="">All Plans</option>
                    <option value="free" {{ request('plan')==='free'?'selected':'' }}>Free</option>
                    <option value="starter" {{ request('plan')==='starter'?'selected':'' }}>Starter</option>
                    <option value="business" {{ request('plan')==='business'?'selected':'' }}>Business</option>
                    <option value="enterprise" {{ request('plan')==='enterprise'?'selected':'' }}>Enterprise</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.companies') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Companies Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>Company</th>
                        <th>Owner</th>
                        <th>Location</th>
                        <th>Plan</th>
                        <th class="text-center">Jobs</th>
                        <th>Rating</th>
                        <th>Verified</th>
                        <th>Created</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($companies as $company)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $company->id }}"></td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                @if($company->logo)
                                    <img src="{{ asset('storage/'.$company->logo) }}" width="32" height="32" class="rounded" alt="">
                                @else
                                    <div class="avatar-item avatar-xs avatar-title rounded bg-primary-subtle text-primary" style="width:32px;height:32px;font-size:11px;">{{ strtoupper(substr($company->name,0,2)) }}</div>
                                @endif
                                <div>
                                    <span class="fw-medium">{{ $company->name }}</span>
                                    @if($company->website)<br><a href="{{ $company->website }}" target="_blank" class="fs-12 text-muted">{{ parse_url($company->website, PHP_URL_HOST) }}</a>@endif
                                </div>
                            </div>
                        </td>
                        <td>
                            @if($company->owner)
                                <span class="fs-13">{{ $company->owner->name }}</span><br>
                                <span class="text-muted fs-12">{{ $company->owner->email }}</span>
                            @else <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td class="text-muted fs-13">{{ $company->location ?? '—' }}</td>
                        <td>
                            @php $pc = match($company->plan ?? 'free'){ 'enterprise'=>'danger','business'=>'warning','starter'=>'info','free'=>'secondary',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $pc }}-subtle text-{{ $pc }}">{{ ucfirst($company->plan ?? 'free') }}</span>
                        </td>
                        <td class="text-center"><span class="badge bg-primary-subtle text-primary">{{ $company->jobs()->count() }}</span></td>
                        <td>
                            @if($company->rating_count > 0)
                                <span class="text-warning"><i class="ri-star-fill"></i></span>
                                <span class="fw-medium">{{ number_format($company->rating_avg, 1) }}</span>
                                <span class="text-muted fs-12">({{ $company->rating_count }})</span>
                            @else <span class="text-muted fs-12">No reviews</span>
                            @endif
                        </td>
                        <td>
                            @if($company->verified)
                                <span class="badge bg-success-subtle text-success"><i class="ri-checkbox-circle-fill me-1"></i>Yes</span>
                            @else
                                <span class="badge bg-secondary-subtle text-secondary">No</span>
                            @endif
                        </td>
                        <td class="text-muted fs-12">{{ $company->created_at->format('M d, Y') }}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#"><i class="ri-eye-line me-2"></i>View</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="ri-edit-line me-2"></i>Edit</a></li>
                                    @if(!$company->verified)
                                        <li><a class="dropdown-item text-success" href="#"><i class="ri-verified-badge-line me-2"></i>Verify</a></li>
                                    @else
                                        <li><a class="dropdown-item text-warning" href="#"><i class="ri-close-circle-line me-2"></i>Unverify</a></li>
                                    @endif
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="ri-delete-bin-line me-2"></i>Delete</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="10" class="text-center text-muted py-5">
                            <i class="ri-building-line fs-1 d-block mb-2 opacity-50"></i>No companies found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($companies->hasPages())
    <div class="card-footer">{{ $companies->withQueryString()->links() }}</div>
    @endif
</div>

<!-- Add Company Modal -->
<div class="modal fade" id="addCompanyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Add Company</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addCompanyForm">
                    <div class="mb-3"><label class="form-label">Company Name</label><input type="text" class="form-control" name="name" required></div>
                    <div class="row mb-3">
                        <div class="col-6"><label class="form-label">Website</label><input type="url" class="form-control" name="website" placeholder="https://"></div>
                        <div class="col-6"><label class="form-label">Location</label><input type="text" class="form-control" name="location" placeholder="Malta, Curacao..."></div>
                    </div>
                    <div class="mb-3"><label class="form-label">Description</label><textarea class="form-control" name="description" rows="3"></textarea></div>
                    <div class="row mb-3">
                        <div class="col-4"><label class="form-label">Size</label><input type="text" class="form-control" name="size" placeholder="50-200"></div>
                        <div class="col-4"><label class="form-label">Founded</label><input type="number" class="form-control" name="founded_year" placeholder="2020"></div>
                        <div class="col-4"><label class="form-label">Plan</label>
                            <select class="form-select" name="plan"><option value="free">Free</option><option value="starter">Starter</option><option value="business">Business</option><option value="enterprise">Enterprise</option></select>
                        </div>
                    </div>
                    <div class="form-check mb-3"><input class="form-check-input" type="checkbox" name="verified" id="verifiedCheck"><label class="form-check-label" for="verifiedCheck">Mark as Verified</label></div>
                </form>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary">Create Company</button></div>
        </div>
    </div>
</div>
@endsection

@section('js')
<script>document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});</script>
@endsection
