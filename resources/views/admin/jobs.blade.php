@extends('admin.partials.layouts.master')

@section('title', 'Job Listings — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Job Listings')
@section('buttonTitle', '+ Post Job')
@section('modalTarget', 'createJobModal')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-briefcase-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Jobs</p><h4 class="mb-0 fw-semibold">{{ $jobs->total() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-checkbox-circle-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Active</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Job::active()->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-warning-subtle text-warning rounded-2"><i class="ri-star-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Featured</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Job::featured()->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-danger-subtle text-danger rounded-2"><i class="ri-fire-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Urgent</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Job::urgent()->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search job title..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="status" class="form-select form-select-sm">
                    <option value="">All Statuses</option>
                    <option value="active" {{ request('status')==='active'?'selected':'' }}>Active</option>
                    <option value="draft" {{ request('status')==='draft'?'selected':'' }}>Draft</option>
                    <option value="paused" {{ request('status')==='paused'?'selected':'' }}>Paused</option>
                    <option value="expired" {{ request('status')==='expired'?'selected':'' }}>Expired</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="type" class="form-select form-select-sm">
                    <option value="">All Types</option>
                    <option value="full-time" {{ request('type')==='full-time'?'selected':'' }}>Full-time</option>
                    <option value="part-time" {{ request('type')==='part-time'?'selected':'' }}>Part-time</option>
                    <option value="contract" {{ request('type')==='contract'?'selected':'' }}>Contract</option>
                    <option value="freelance" {{ request('type')==='freelance'?'selected':'' }}>Freelance</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="level" class="form-select form-select-sm">
                    <option value="">All Levels</option>
                    <option value="c-level" {{ request('level')==='c-level'?'selected':'' }}>C-Level</option>
                    <option value="head" {{ request('level')==='head'?'selected':'' }}>Head</option>
                    <option value="senior" {{ request('level')==='senior'?'selected':'' }}>Senior</option>
                    <option value="middle" {{ request('level')==='middle'?'selected':'' }}>Middle</option>
                    <option value="junior" {{ request('level')==='junior'?'selected':'' }}>Junior</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.jobs') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Jobs Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>Job Title</th>
                        <th>Company</th>
                        <th>Level</th>
                        <th>Salary</th>
                        <th>Mode</th>
                        <th>Status</th>
                        <th class="text-center">Views</th>
                        <th class="text-center">Apps</th>
                        <th>Posted</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($jobs as $job)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $job->id }}"></td>
                        <td>
                            <div>
                                <span class="fw-medium">{{ $job->title }}</span>
                                <div class="d-flex gap-1 mt-1">
                                    @if($job->is_featured)<span class="badge bg-warning-subtle text-warning fs-10"><i class="ri-star-fill me-1"></i>Featured</span>@endif
                                    @if($job->is_urgent)<span class="badge bg-danger-subtle text-danger fs-10"><i class="ri-fire-fill me-1"></i>Urgent</span>@endif
                                    @if($job->job_type)<span class="badge bg-light text-dark fs-10">{{ ucfirst($job->job_type->value) }}</span>@endif
                                </div>
                            </div>
                        </td>
                        <td>
                            @if($job->company)
                                <div class="d-flex align-items-center gap-2">
                                    @if($job->company->logo)
                                        <img src="{{ asset('storage/'.$job->company->logo) }}" width="24" height="24" class="rounded" alt="">
                                    @else
                                        <div class="avatar-item avatar-xs avatar-title rounded bg-light text-muted" style="width:24px;height:24px;font-size:10px;">{{ strtoupper(substr($job->company->name,0,2)) }}</div>
                                    @endif
                                    <span class="fs-13">{{ $job->company->name }}</span>
                                </div>
                            @else <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td>
                            @if($job->experience_level)
                                @php $lc = match($job->experience_level->value){ 'c-level'=>'danger','head'=>'warning','senior'=>'primary','middle'=>'info','junior'=>'success',default=>'secondary' }; @endphp
                                <span class="badge bg-{{ $lc }}-subtle text-{{ $lc }}">{{ ucfirst($job->experience_level->value) }}</span>
                            @else —
                            @endif
                        </td>
                        <td class="fs-13 text-nowrap">{{ $job->salaryRange() }}</td>
                        <td>
                            @if($job->work_mode)
                                @php $mc = match($job->work_mode->value){ 'remote'=>'success','hybrid'=>'warning','on-site'=>'info',default=>'secondary' }; @endphp
                                <span class="badge bg-{{ $mc }}-subtle text-{{ $mc }}">{{ ucfirst($job->work_mode->value) }}</span>
                            @else —
                            @endif
                        </td>
                        <td>
                            @php $sc = match($job->status ?? 'draft'){ 'active'=>'success','draft'=>'secondary','paused'=>'warning','expired'=>'danger',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $sc }}-subtle text-{{ $sc }}">{{ ucfirst($job->status ?? 'draft') }}</span>
                        </td>
                        <td class="text-center text-muted">{{ number_format($job->views_count ?? 0) }}</td>
                        <td class="text-center"><span class="badge bg-primary-subtle text-primary">{{ $job->applications_count ?? 0 }}</span></td>
                        <td class="text-muted fs-12">{{ $job->created_at->format('M d, Y') }}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#"><i class="ri-eye-line me-2"></i>View</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="ri-edit-line me-2"></i>Edit</a></li>
                                    @if(($job->status ?? 'draft') === 'active')
                                        <li><a class="dropdown-item text-warning" href="#"><i class="ri-pause-circle-line me-2"></i>Pause</a></li>
                                    @else
                                        <li><a class="dropdown-item text-success" href="#"><i class="ri-play-circle-line me-2"></i>Activate</a></li>
                                    @endif
                                    <li><a class="dropdown-item" href="#"><i class="ri-star-line me-2"></i>{{ $job->is_featured ? 'Unfeature' : 'Feature' }}</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="ri-delete-bin-line me-2"></i>Delete</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="11" class="text-center text-muted py-5">
                            <i class="ri-briefcase-line fs-1 d-block mb-2 opacity-50"></i>No job listings found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($jobs->hasPages())
    <div class="card-footer">{{ $jobs->withQueryString()->links() }}</div>
    @endif
</div>

<!-- Create Job Modal -->
<div class="modal fade" id="createJobModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Post New Job</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="createJobForm">
                    <div class="row mb-3">
                        <div class="col-8"><label class="form-label">Job Title</label><input type="text" class="form-control" name="title" required placeholder="e.g. Senior Casino Product Manager"></div>
                        <div class="col-4"><label class="form-label">Company</label>
                            <select class="form-select" name="company_id"><option value="">Select...</option>
                                @foreach(\App\Models\Company::orderBy('name')->get() as $c)<option value="{{ $c->id }}">{{ $c->name }}</option>@endforeach
                            </select>
                        </div>
                    </div>
                    <div class="mb-3"><label class="form-label">Description</label><textarea class="form-control" name="description" rows="4" placeholder="Job description..."></textarea></div>
                    <div class="mb-3"><label class="form-label">Requirements</label><textarea class="form-control" name="requirements" rows="3" placeholder="Requirements..."></textarea></div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Category</label>
                            <select class="form-select" name="category_id">
                                @foreach(\App\Models\JobCategory::orderBy('name')->get() as $cat)<option value="{{ $cat->id }}">{{ $cat->name }}</option>@endforeach
                            </select>
                        </div>
                        <div class="col-md-3"><label class="form-label">Experience</label>
                            <select class="form-select" name="experience_level"><option value="junior">Junior</option><option value="middle">Middle</option><option value="senior" selected>Senior</option><option value="head">Head</option><option value="c-level">C-Level</option></select>
                        </div>
                        <div class="col-md-3"><label class="form-label">Job Type</label>
                            <select class="form-select" name="job_type"><option value="full-time">Full-time</option><option value="part-time">Part-time</option><option value="contract">Contract</option><option value="freelance">Freelance</option></select>
                        </div>
                        <div class="col-md-3"><label class="form-label">Work Mode</label>
                            <select class="form-select" name="work_mode"><option value="remote">Remote</option><option value="on-site">On-site</option><option value="hybrid">Hybrid</option></select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"><label class="form-label">Salary Min</label><input type="number" class="form-control" name="salary_min" placeholder="3000"></div>
                        <div class="col-md-3"><label class="form-label">Salary Max</label><input type="number" class="form-control" name="salary_max" placeholder="6000"></div>
                        <div class="col-md-3"><label class="form-label">Currency</label><select class="form-select" name="salary_currency"><option value="USD">USD</option><option value="EUR">EUR</option><option value="GBP">GBP</option><option value="USDT">USDT</option></select></div>
                        <div class="col-md-3"><label class="form-label">Location</label><input type="text" class="form-control" name="location" placeholder="Remote / Malta"></div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6"><label class="form-label">Tags (comma separated)</label><input type="text" class="form-control" name="tags" placeholder="casino, slots, igaming"></div>
                        <div class="col-md-3"><div class="form-check mt-4"><input class="form-check-input" type="checkbox" name="is_featured" id="isFeatured"><label class="form-check-label" for="isFeatured">Featured</label></div></div>
                        <div class="col-md-3"><div class="form-check mt-4"><input class="form-check-input" type="checkbox" name="is_urgent" id="isUrgent"><label class="form-check-label" for="isUrgent">Urgent</label></div></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary">Post Job</button></div>
        </div>
    </div>
</div>
@endsection

@section('js')
<script>document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});</script>
@endsection
