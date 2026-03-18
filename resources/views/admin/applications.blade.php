@extends('admin.partials.layouts.master')

@section('title', 'Applications — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Applications')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-file-list-3-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Applications</p><h4 class="mb-0 fw-semibold">{{ $applications->total() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-warning-subtle text-warning rounded-2"><i class="ri-time-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Pending</p><h4 class="mb-0 fw-semibold">{{ \App\Models\JobApplication::where('status', 'pending')->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-info-subtle text-info rounded-2"><i class="ri-bookmark-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Shortlisted</p><h4 class="mb-0 fw-semibold">{{ \App\Models\JobApplication::where('status', 'shortlisted')->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-check-double-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Hired</p><h4 class="mb-0 fw-semibold">{{ \App\Models\JobApplication::where('status', 'hired')->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search candidate or job..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="status" class="form-select form-select-sm">
                    <option value="">All Statuses</option>
                    <option value="pending" {{ request('status')==='pending'?'selected':'' }}>Pending</option>
                    <option value="reviewed" {{ request('status')==='reviewed'?'selected':'' }}>Reviewed</option>
                    <option value="shortlisted" {{ request('status')==='shortlisted'?'selected':'' }}>Shortlisted</option>
                    <option value="rejected" {{ request('status')==='rejected'?'selected':'' }}>Rejected</option>
                    <option value="hired" {{ request('status')==='hired'?'selected':'' }}>Hired</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.applications') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Applications Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>Candidate</th>
                        <th>Job Position</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Resume</th>
                        <th>Applied</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($applications as $app)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $app->id }}"></td>
                        <td>
                            @if($app->candidate)
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-item avatar-xs avatar-title rounded-circle text-white" style="background:var(--bs-primary);font-size:11px;width:32px;height:32px;">{{ strtoupper(substr($app->candidate->name,0,1)) }}</div>
                                    <div>
                                        <span class="fw-medium">{{ $app->candidate->name }}</span><br>
                                        <span class="text-muted fs-12">{{ $app->candidate->email }}</span>
                                    </div>
                                </div>
                            @else <span class="text-muted">Deleted user</span>
                            @endif
                        </td>
                        <td>
                            @if($app->job)
                                <span class="fw-medium fs-13">{{ $app->job->title }}</span>
                            @else <span class="text-muted">Deleted job</span>
                            @endif
                        </td>
                        <td class="text-muted fs-13">{{ $app->job->company->name ?? '—' }}</td>
                        <td>
                            @php $asc = match($app->status->value){ 'pending'=>'warning','reviewed'=>'info','shortlisted'=>'primary','rejected'=>'danger','hired'=>'success',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $asc }}-subtle text-{{ $asc }}">{{ $app->status->label() }}</span>
                        </td>
                        <td>
                            @if($app->resume_path)
                                <a href="{{ asset('storage/'.$app->resume_path) }}" target="_blank" class="btn btn-sm btn-subtle-primary"><i class="ri-file-download-line me-1"></i>CV</a>
                            @else <span class="text-muted fs-12">No CV</span>
                            @endif
                        </td>
                        <td class="text-muted fs-12">{{ $app->created_at->format('M d, Y') }}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#viewAppModal" data-app='@json($app->load("candidate","job.company"))'><i class="ri-eye-line me-2"></i>View Details</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li class="dropdown-header">Change Status</li>
                                    <li><a class="dropdown-item {{ $app->status->value==='reviewed'?'active':'' }}" href="#"><i class="ri-eye-fill me-2 text-info"></i>Reviewed</a></li>
                                    <li><a class="dropdown-item {{ $app->status->value==='shortlisted'?'active':'' }}" href="#"><i class="ri-bookmark-fill me-2 text-primary"></i>Shortlisted</a></li>
                                    <li><a class="dropdown-item {{ $app->status->value==='hired'?'active':'' }}" href="#"><i class="ri-check-double-fill me-2 text-success"></i>Hired</a></li>
                                    <li><a class="dropdown-item {{ $app->status->value==='rejected'?'active':'' }}" href="#"><i class="ri-close-circle-fill me-2 text-danger"></i>Rejected</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="#"><i class="ri-delete-bin-line me-2"></i>Delete</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="8" class="text-center text-muted py-5">
                            <i class="ri-file-list-3-line fs-1 d-block mb-2 opacity-50"></i>No applications found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($applications->hasPages())
    <div class="card-footer">{{ $applications->withQueryString()->links() }}</div>
    @endif
</div>

<!-- View Application Modal -->
<div class="modal fade" id="viewAppModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Application Details</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body" id="viewAppBody"></div>
        </div>
    </div>
</div>
@endsection

@section('js')
<script>
document.querySelectorAll('[data-bs-target="#viewAppModal"]').forEach(btn=>{
    btn.addEventListener('click',function(){
        const a=JSON.parse(this.dataset.app);
        const sc=({pending:'warning',reviewed:'info',shortlisted:'primary',rejected:'danger',hired:'success'})[a.status]||'secondary';
        document.getElementById('viewAppBody').innerHTML=`
            <div class="row">
                <div class="col-md-6">
                    <h6 class="text-muted mb-2">Candidate</h6>
                    <h5>${a.candidate?.name||'—'}</h5>
                    <p class="text-muted mb-1">${a.candidate?.email||''}</p>
                    <p class="text-muted mb-3">${a.candidate?.phone||''}</p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-2">Job Position</h6>
                    <h5>${a.job?.title||'—'}</h5>
                    <p class="text-muted mb-1">${a.job?.company?.name||'—'}</p>
                    <span class="badge bg-${sc}-subtle text-${sc}">${a.status}</span>
                </div>
            </div>
            ${a.cover_letter?`<hr><h6 class="text-muted mb-2">Cover Letter</h6><p>${a.cover_letter}</p>`:''}
            ${a.employer_notes?`<hr><h6 class="text-muted mb-2">Employer Notes</h6><p>${a.employer_notes}</p>`:''}
            <hr><p class="text-muted fs-12">Applied: ${new Date(a.created_at).toLocaleDateString()}</p>`;
    });
});
document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});
</script>
@endsection
