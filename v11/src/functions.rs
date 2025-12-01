use std::{
    alloc::{alloc, dealloc, Layout},
    ptr,
};

pub struct Array<T> {
    ptr: *mut T,
    len: usize,
    layout: Layout,
}

impl<T> Array<T> {
    pub unsafe fn new(len: usize) -> Self {
        let layout = Layout::array::<T>(len).expect("err");
        let ptr = alloc(layout) as *mut T;
        if ptr.is_null() {
            std::alloc::handle_alloc_error(layout);
        }
        return Array { ptr, len, layout };
    }

    pub unsafe fn element_at(&self, index: usize) -> &T {
        if index >= self.len {
            panic!("index out of bounds");
        }
        let base = self.ptr;
        let ptr = base.add(index);
        &*ptr
    }

    pub unsafe fn set(&self, index: usize, elem: T) {
        if index >= self.len {
            panic!("index out of bounds");
        }
        let base = self.ptr;
        let ptr = base.add(index);
        ptr::write(ptr, elem);
    }
}

impl<T> Drop for Array<T> {
    fn drop(&mut self) {
        unsafe {
            dealloc(self.ptr as *mut u8, self.layout);
        }
    }
}
