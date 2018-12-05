open BsUiLibrary

type person = { 
  name: string; 
  age: int;
  favoriteAnimal: string }

let person_to_bsObj (p: person) = 
  [%bs.obj { __tag = "PersonView"; name = p.name; age = p.age; animal = p.favoriteAnimal}]

(* type animal = { name: string }
type pet = { name: string; animal: animal } *)

let animalOptions = [ "Cat"; "Dog"; "Pig" ]

let personEditor =
  Block.(Controls.ValidatedEditor.(
    ((fun n a fa -> { name = n; age = a; favoriteAnimal = fa }),
     (fun n a fa -> [%bs.obj { __tag = "PersonEditor"; name = n; age = a; animal = fa }]))
    <!> field (fun x -> x.name) (string_textbox |> map_value (Validated.bind (Validated.required "")))
    <*> field (fun x -> x.age) int_textbox
    <*> field (fun x -> x.favoriteAnimal) (string_textbox |> map_value (Validated.bind (Validated.required "")))))

let viewer f =
  Block.(static |> map_model f)

let withValueViewer f block =
    Block.(
      (block, viewer f)
      |> Reactor.mkBlock2
          (fun (a,b1,b2) -> 
              match a with 
              | Left _ -> [ Right (Reactor.ReInit b1.value) ]
              | Right _ -> [])
      |> map_init (fun x -> x, (block.getValue (block.initialize x).newState))
      |> map_value fst
      |> map_model (fun (l,r) -> [%bs.obj {
          __tag = "WithValueViewer";
          inner = l;
          value = r;
      }]))

let demo_block = 
  Block.(
    personEditor 
    |> map_init (fun () -> None)
    |> withValueViewer (Validated.to_bsObj person_to_bsObj)
    |> map_value ignore)

let demo1 = BsUiLibrary.Runner.run demo_block
