open BsUiLibrary
open Util

type person = { name: string; age: int }
let person_to_bsObj (p: person) = 
  [%bs.obj { __tag = "PersonView"; name = p.name; age = p.age }]

(* type animal = { name: string }
type pet = { name: string; animal: animal } *)

let animalOptions = [ "Cat"; "Dog"; "Pig" ]

let personEditor =
  Editor.(Block2.(
    ((fun n a -> { name = n; age = a }),
    (fun n a -> [%bs.obj { __tag = "PersonEditor"; name = n; age = a }]))
    <!> field (fun x -> x.name) (stringEditor |> mapValue (Validated.bind (Validated.required "")))
    <*> field (fun x -> x.age) intEditor
  ))

(* let creator: Editor<Types.Portion, _, _, _, _> =
    record "PortionAdder" (
        fun (a,f)-> { Food = f; Amount = a; }
        <!> field "FoodAmount" (fun ri -> (ri.Amount, ri.Food)) FoodAmountSelector.block
    )
 *)

let viewer f =
  Block2.(
    static |> mapModel f
  )

let withValueViewer f block =
    Block2.(
      (block, viewer f)
      |> Reactor.mkBlock2
          (fun (a,b1,b2) -> 
              match a with 
              | Left _ -> [ Right (Reactor.ReInit b1.value) ]
              | Right _ -> [])
      |> mapInit (fun x -> x, (block.getValue (block.initialize x).newState))
      |> mapValue fst
      |> mapModel (fun (l,r) -> [%bs.obj {
          __tag = "WithValueViewer";
          inner = l;
          value = r;
      }])
    )

let demo1 = 
  Block2.(
    personEditor 
    |> mapInit (fun () -> None)
    |> withValueViewer (Validated.to_bsObj person_to_bsObj)
    |> mapValue ignore
  )
