// Make this only by reordering the lines in `main()`, but without
// adding, changing or removing any of them.
fn exercise5() {
    let mut x = vec![100];
    let y = &mut x;
    y.push(200);
    let z = &mut x;
    z.push(300);
    assert_eq!(x, vec![100, 200, 300]);
}
