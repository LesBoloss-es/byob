let rec range a b =
  if a > b then []
  else a :: range (a + 1) b

let zip_with f = List.map (fun x -> x, f x)

let test a b c =
  range a b
  |> zip_with (fun x -> 2 * x + 1)
  |> List.assoc c

let lol a = test a (2 * a) (a -1)

let lol' () =
  try lol 42 with exn -> raise exn


let () =
  Format.printf "%d@." (lol' ())

