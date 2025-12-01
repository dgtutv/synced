use std::ffi::CString;
use std::os::raw::{c_char, c_int, c_void};
use crate::language::*;

#[no_mangle]
pub extern "C" fn new_int(x: c_int) -> *mut Value {
    let iv = Box::new(IntValue(x));
    Box::into_raw(Box::new(Value {
        ptr: Box::into_raw(iv) as *mut c_void,
    }))
}

#[no_mangle]
pub extern "C" fn new_vec() -> *mut Value {
    let vv = Box::new(VecValue(Vec::new()));
    Box::into_raw(Box::new(Value {
        ptr: Box::into_raw(vv) as *mut c_void,
    }))
}

#[no_mangle]
pub extern "C" fn vec_push(vec: *mut Value, v: *mut Value) {
    unsafe {
        let vv = &mut *((*vec).ptr as *mut VecValue);
        vv.0.push(v as *mut c_void);
    }
}

pub unsafe fn int_val(v: *mut Value) -> i32 {
    return (&*((*v).ptr as *mut IntValue)).0
}

pub unsafe fn borrowed_vec_val<'a>(v: *mut Value) -> &'a Vec<*mut c_void>{
    return &(&*((*v).ptr as *mut VecValue)).0
}

#[no_mangle]
pub extern "C" fn show_int(v: *mut Value) -> *mut c_char {
    unsafe {
        let iv = &*((*v).ptr as *mut IntValue);
        CString::new(iv.0.to_string()).unwrap().into_raw()
    }
}

#[no_mangle]
pub extern "C" fn show_vec(v: *mut Value) -> *mut c_char {
    unsafe {
        let vv = borrowed_vec_val(v);
        let mut out = String::from("[");
        for (i, &elem) in vv.iter().enumerate() {
            let s = CString::from_raw(show_int(elem as *mut Value)).into_string().unwrap();
            out.push_str(&s);
            if i + 1 < vv.len() {
                out.push_str(", ");
            }
        }
        out.push(']');
        CString::new(out).unwrap().into_raw()
    }
}

#[no_mangle]
pub extern "C" fn free_string(s: *mut c_char) {
    if s.is_null() { return; }
    unsafe {
        drop(CString::from_raw(s));
    }
}