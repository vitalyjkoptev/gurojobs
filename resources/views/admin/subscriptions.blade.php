@extends('admin.partials.layouts.master')

@section('title', 'Subscriptions — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Subscriptions')

@section('content')

<!-- Pricing Plans Overview -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100 border-bottom border-3 border-secondary">
            <div class="card-body text-center">
                <i class="ri-user-line display-6 text-secondary mb-2"></i>
                <h6 class="text-muted mb-1">Free</h6>
                <h3 class="fw-bold mb-1">$0<small class="fs-13 fw-normal text-muted">/mo</small></h3>
                <p class="text-muted fs-12 mb-2">1 job / month</p>
                <span class="badge bg-secondary-subtle text-secondary">{{ \App\Models\Subscription::where('plan','free')->where('status','active')->count() }} active</span>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100 border-bottom border-3 border-info">
            <div class="card-body text-center">
                <i class="ri-rocket-line display-6 text-info mb-2"></i>
                <h6 class="text-muted mb-1">Starter</h6>
                <h3 class="fw-bold mb-1">$49<small class="fs-13 fw-normal text-muted">/mo</small></h3>
                <p class="text-muted fs-12 mb-2">10 jobs / month</p>
                <span class="badge bg-info-subtle text-info">{{ \App\Models\Subscription::where('plan','starter')->where('status','active')->count() }} active</span>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100 border-bottom border-3 border-warning">
            <div class="card-body text-center">
                <i class="ri-vip-diamond-line display-6 text-warning mb-2"></i>
                <h6 class="text-muted mb-1">Business</h6>
                <h3 class="fw-bold mb-1">$149<small class="fs-13 fw-normal text-muted">/mo</small></h3>
                <p class="text-muted fs-12 mb-2">50 jobs / month</p>
                <span class="badge bg-warning-subtle text-warning">{{ \App\Models\Subscription::where('plan','business')->where('status','active')->count() }} active</span>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100 border-bottom border-3 border-danger">
            <div class="card-body text-center">
                <i class="ri-vip-crown-line display-6 text-danger mb-2"></i>
                <h6 class="text-muted mb-1">Enterprise</h6>
                <h3 class="fw-bold mb-1">$499<small class="fs-13 fw-normal text-muted">/mo</small></h3>
                <p class="text-muted fs-12 mb-2">Unlimited jobs</p>
                <span class="badge bg-danger-subtle text-danger">{{ \App\Models\Subscription::where('plan','enterprise')->where('status','active')->count() }} active</span>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search company or user..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="plan" class="form-select form-select-sm">
                    <option value="">All Plans</option>
                    <option value="free" {{ request('plan')==='free'?'selected':'' }}>Free</option>
                    <option value="starter" {{ request('plan')==='starter'?'selected':'' }}>Starter</option>
                    <option value="business" {{ request('plan')==='business'?'selected':'' }}>Business</option>
                    <option value="enterprise" {{ request('plan')==='enterprise'?'selected':'' }}>Enterprise</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="status" class="form-select form-select-sm">
                    <option value="">All Statuses</option>
                    <option value="active" {{ request('status')==='active'?'selected':'' }}>Active</option>
                    <option value="expired" {{ request('status')==='expired'?'selected':'' }}>Expired</option>
                    <option value="cancelled" {{ request('status')==='cancelled'?'selected':'' }}>Cancelled</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.subscriptions') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Subscriptions Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>Company</th>
                        <th>User</th>
                        <th>Plan</th>
                        <th>Status</th>
                        <th>Started</th>
                        <th>Expires</th>
                        <th>Days Left</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($subscriptions as $sub)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $sub->id }}"></td>
                        <td>
                            @if($sub->company)
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-item avatar-xs avatar-title rounded bg-primary-subtle text-primary" style="width:28px;height:28px;font-size:10px;">{{ strtoupper(substr($sub->company->name,0,2)) }}</div>
                                    <span class="fw-medium fs-13">{{ $sub->company->name }}</span>
                                </div>
                            @else <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td>
                            @if($sub->user)
                                <span class="fs-13">{{ $sub->user->name }}</span><br>
                                <span class="text-muted fs-12">{{ $sub->user->email }}</span>
                            @else <span class="text-muted">—</span>
                            @endif
                        </td>
                        <td>
                            @php $plc = match($sub->plan ?? 'free'){ 'enterprise'=>'danger','business'=>'warning','starter'=>'info','free'=>'secondary',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $plc }}-subtle text-{{ $plc }}">{{ ucfirst($sub->plan ?? 'free') }}</span>
                        </td>
                        <td>
                            @php $ssc = match($sub->status ?? 'active'){ 'active'=>'success','expired'=>'danger','cancelled'=>'secondary',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $ssc }}-subtle text-{{ $ssc }}">{{ ucfirst($sub->status ?? 'active') }}</span>
                        </td>
                        <td class="text-muted fs-12">{{ $sub->starts_at?->format('M d, Y') ?? '—' }}</td>
                        <td class="text-muted fs-12">{{ $sub->expires_at?->format('M d, Y') ?? '—' }}</td>
                        <td>
                            @if($sub->expires_at && $sub->expires_at->isFuture())
                                @php $days = now()->diffInDays($sub->expires_at); @endphp
                                <span class="badge bg-{{ $days > 14 ? 'success' : ($days > 3 ? 'warning' : 'danger') }}-subtle text-{{ $days > 14 ? 'success' : ($days > 3 ? 'warning' : 'danger') }}">{{ $days }}d</span>
                            @elseif($sub->expires_at)
                                <span class="badge bg-danger-subtle text-danger">Expired</span>
                            @else —
                            @endif
                        </td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#"><i class="ri-eye-line me-2"></i>View</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="ri-edit-line me-2"></i>Edit</a></li>
                                    <li><a class="dropdown-item text-success" href="#"><i class="ri-refresh-line me-2"></i>Extend</a></li>
                                    @if(($sub->status ?? 'active') === 'active')
                                        <li><a class="dropdown-item text-danger" href="#"><i class="ri-close-circle-line me-2"></i>Cancel</a></li>
                                    @endif
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="9" class="text-center text-muted py-5">
                            <i class="ri-vip-crown-line fs-1 d-block mb-2 opacity-50"></i>No subscriptions found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($subscriptions->hasPages())
    <div class="card-footer">{{ $subscriptions->withQueryString()->links() }}</div>
    @endif
</div>
@endsection

@section('js')
<script>document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});</script>
@endsection
