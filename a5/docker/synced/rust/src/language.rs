use std::os::raw::{c_void};

#[repr(C)]
pub struct IntValue(pub i32);

#[repr(C)]
pub struct VecValue(pub Vec<*mut c_void>);

#[repr(C)]
pub struct Value {
    pub ptr: *mut c_void,
}