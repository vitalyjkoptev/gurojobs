@extends('admin.partials.layouts.master')

@section('title', 'Categories — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Job Categories')
@section('buttonTitle', '+ Add Category')
@section('modalTarget', 'addCategoryModal')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-4 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-folder-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Categories</p><h4 class="mb-0 fw-semibold">{{ $categories->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-4 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-briefcase-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Jobs</p><h4 class="mb-0 fw-semibold">{{ $categories->sum('jobs_count') }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-4 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-warning-subtle text-warning rounded-2"><i class="ri-folder-warning-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Empty Categories</p><h4 class="mb-0 fw-semibold">{{ $categories->where('jobs_count', 0)->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Categories Grid -->
<div class="row g-3">
    @forelse($categories as $category)
    <div class="col-xl-3 col-md-4 col-sm-6">
        <div class="card card-h-100 card-hover">
            <div class="card-body">
                <div class="d-flex align-items-start justify-content-between mb-3">
                    <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2">
                        <i class="{{ $category->icon ?? 'ri-folder-line' }} fs-18"></i>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-subtle-secondary p-1" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#"><i class="ri-edit-line me-2"></i>Edit</a></li>
                            <li><a class="dropdown-item text-danger" href="#"><i class="ri-delete-bin-line me-2"></i>Delete</a></li>
                        </ul>
                    </div>
                </div>
                <h6 class="fw-semibold mb-1">{{ $category->name }}</h6>
                <p class="text-muted fs-12 mb-2">{{ $category->slug }}</p>
                @if($category->description)
                    <p class="text-muted fs-13 mb-2" style="display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;">{{ $category->description }}</p>
                @endif
                <div class="d-flex align-items-center gap-2 mt-auto">
                    <span class="badge bg-primary-subtle text-primary"><i class="ri-briefcase-line me-1"></i>{{ $category->jobs_count }} jobs</span>
                    @if($category->sort_order)
                        <span class="badge bg-light text-muted">Order: {{ $category->sort_order }}</span>
                    @endif
                </div>
            </div>
        </div>
    </div>
    @empty
    <div class="col-12">
        <div class="card">
            <div class="card-body text-center py-5 text-muted">
                <i class="ri-folder-line fs-1 d-block mb-2 opacity-50"></i>No categories found
            </div>
        </div>
    </div>
    @endforelse
</div>

<!-- Also show as table -->
<div class="card mt-4">
    <div class="card-header"><h5 class="card-title mb-0">Categories List</h5></div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:50px">#</th>
                        <th>Icon</th>
                        <th>Name</th>
                        <th>Slug</th>
                        <th class="text-center">Jobs</th>
                        <th>Order</th>
                        <th style="width:100px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($categories as $i => $category)
                    <tr>
                        <td class="text-muted">{{ $i + 1 }}</td>
                        <td><i class="{{ $category->icon ?? 'ri-folder-line' }} fs-18 text-primary"></i></td>
                        <td class="fw-medium">{{ $category->name }}</td>
                        <td class="text-muted fs-13">{{ $category->slug }}</td>
                        <td class="text-center"><span class="badge bg-primary-subtle text-primary">{{ $category->jobs_count }}</span></td>
                        <td class="text-muted">{{ $category->sort_order ?? '—' }}</td>
                        <td>
                            <a href="#" class="btn btn-sm btn-subtle-primary me-1"><i class="ri-edit-line"></i></a>
                            <a href="#" class="btn btn-sm btn-subtle-danger"><i class="ri-delete-bin-line"></i></a>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Add Category</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addCategoryForm">
                    <div class="mb-3"><label class="form-label">Category Name</label><input type="text" class="form-control" name="name" required placeholder="e.g. Casino & Slots"></div>
                    <div class="row mb-3">
                        <div class="col-6"><label class="form-label">Slug</label><input type="text" class="form-control" name="slug" placeholder="casino-slots"></div>
                        <div class="col-6"><label class="form-label">Icon Class</label><input type="text" class="form-control" name="icon" placeholder="ri-gamepad-line" value="ri-folder-line"></div>
                    </div>
                    <div class="mb-3"><label class="form-label">Description</label><textarea class="form-control" name="description" rows="2" placeholder="Category description..."></textarea></div>
                    <div class="mb-3"><label class="form-label">Sort Order</label><input type="number" class="form-control" name="sort_order" value="0"></div>
                </form>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary">Create Category</button></div>
        </div>
    </div>
</div>
@endsection
