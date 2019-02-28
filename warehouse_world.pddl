(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?ol - location ?nl - location)
      :precondition (and (at ?r ?ol) (no-robot ?nl) (free ?r) (connected ?ol ?nl))
      :effect (and (not (at ?r ?ol)) (not (no-robot ?nl)) (at ?r ?nl) (no-robot ?ol))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?ol - location ?nl - location)
      :precondition (and (at ?r ?ol) (at ?p ?ol) (no-robot ?nl) (no-pallette ?nl) (connected ?ol ?nl))
      :effect (and (has ?r ?p) (not (at ?r ?ol)) (at ?r ?nl) (not (at ?p ?ol)) (at ?p ?nl) (not (no-robot ?nl)) (no-robot ?ol) (not (no-pallette ?nl)) (no-pallette ?ol))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?p - pallette ?l - location ?s - shipment ?i - saleitem)
      :precondition (and (at ?p ?l) (packing-at ?s ?l) (contains ?p ?i))
      :effect (and (not (contains ?p ?i)) (includes ?s ?i))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l))
   )

)
