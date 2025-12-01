use std::os::raw::c_int;
mod helpers;
mod language;
use crate::helpers::*;
use crate::language::*;
use std::ffi::CString;
use std::os::raw::{c_char, c_void};

#[no_mangle]
pub extern "C" fn add_values(v1: *mut Value, v2: *mut Value) -> *mut Value {
    unsafe {
        let iv1 = &*((*v1).ptr as *mut IntValue);
        let iv2 = &*((*v2).ptr as *mut IntValue);
        let sum = iv1.0 + iv2.0;
        new_int(sum)
    }
}

#[no_mangle]
pub extern "C" fn head_value(v: *mut Value) -> *mut Value {
    unsafe {
        let vv = &*((*v).ptr as *mut VecValue);
        if vv.0.is_empty() {
            return std::ptr::null_mut();
        }
        vv.0[0] as *mut Value
    }
}

#[no_mangle]
pub extern "C" fn double_value(v: *mut Value) -> *mut Value {
    unsafe {
        let iv_ptr = (*v).ptr;

        // Try to interpret as IntValue first, if it looks like an IntValue interpret and double
        let as_int = iv_ptr as *mut IntValue;
        if !as_int.is_null() {
            let possibly_int = &*as_int;
            return new_int(possibly_int.0 * 2);
        }

        // Otherwise, try to interpret as VecValue
        let as_vec = iv_ptr as *mut VecValue;
        if !as_vec.is_null() {
            let vv = &*as_vec;
            let mut doubled_vec = Box::new(VecValue(Vec::new()));
            for &elem in vv.0.iter() {
                let doubled_elem = double_value(elem as *mut Value);
                doubled_vec.0.push(doubled_elem as *mut c_void);
            }
            Box::into_raw(Box::new(Value {
                ptr: Box::into_raw(doubled_vec) as *mut c_void,
            }))
        } else {
            v
        }
    }
}
