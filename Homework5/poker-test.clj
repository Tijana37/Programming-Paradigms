{:ime "TIJANA" :prezime "ATANASOVSKA" :index "196014"}

(ns user (:use clojure.test))

;1) (suit card)

(deftest test-suit
 (is (= "C" (suit "2C")) )
 (is (= "C" (suit "AC")) )
 (is (= "D" (suit "JD")) )
 (is (= "H" (suit "7H")) )
 (is (= "S" (suit "8S")) )
 )

;2) (rank card)


(deftest test-rank
 (is (= 2 (rank "2C")) )
 (is (= 14 (rank "AC")) )
 (is (= 11 (rank "JD")) )
 (is (= 10 (rank "TH")) )
 (is (= 8 (rank "8S")) )
 )

;3) (pair? hand)

(deftest test-pair?
 (is (true? (pair? ["1C" "2D" "SM" "AH" "AH"])))
 (is (false? (pair? ["1C" "2D" "AH" "AH" "AH"])))
 (is (true? (pair? ["1C" "2D" "SM" "SH" "AH"])))
 )


;4)(three-of-a-kind? hand)

(deftest test-three-of-a-kind?
 (is (false? (three-of-a-kind? ["1C" "2D" "SM" "AH" "AH"])))
 (is (true? (three-of-a-kind? ["1C" "2D" "AH" "AH" "AH"])))
 (is (false? (three-of-a-kind? ["1C" "1C" "AH" "AH" "AH"])))
 (is (false? (three-of-a-kind? ["1C" "AH" "AH" "AH" "AH"])))
)

;5)(four-of-a-kind? hand)

(deftest test-four-of-a-kind?
 (is (false? (four-of-a-kind? ["1C" "2D" "SM" "AH" "AH"])))
 (is (false? (four-of-a-kind? ["1C" "2D" "AH" "AH" "AH"])))
 (is (false? (four-of-a-kind? ["AH" "AH" "AH" "AH" "AH"])))
 (is (true? (four-of-a-kind? ["1C" "AH" "AH" "AH" "AH"])))
)

;6) (flush? hand)

(deftest test-flush?
 (is (false?  (flush? ["9C" "8H" "AH" "AH" "AH"])))
 (is (false?   (flush? ["1H" "2H" "3H" "4H" "5H"])))
 (is (true?   (flush? ["9H" "8H" "AH" "AH" "AH"])))
)

;7) (full-house? hand)

(deftest test-full-house?
 (is (true?  (full-house? ["9H" "9C" "9H" "AH" "AH"])))
 (is (false?  (full-house? ["9H" "10C" "9H" "AH" "AH"])))
 (is (false?  (full-house? ["9H" "9C" "9H" "9H" "AH"])))
)

;8)(two-pairs? hand)

(deftest test-two-pairs?
 (is (true?  (two-pairs? ["9H" "9C" "JC" "AD" "AC"])))
 (is (false?  (two-pairs? ["9H" "9C" "AC" "AC" "AC"])))
)

;9) (straight? hand)

(deftest test-straight?
 (is (true?  (straight? ["AH" "2C" "4C" "3D" "5C"])))
 (is (true?  (straight? ["1H" "2C" "4C" "3D" "5C"])))
 (is (true?  (straight? ["TH" "JC" "QC" "KD" "AC"])))
 (is (false?  (straight? ["TH" "9C" "QC" "KD" "AC"])))
  )

;10)(straight-flush? hand)

(deftest test-straight-flush?
 (is (true?  (straight-flush? ["6H" "7H" "8H" "9H" "TH"])))
 (is (false?  (straight-flush? ["TH" "9C" "QC" "KD" "7C"])))
 (is (true?  (straight-flush? ["2H" "3H" "6H" "5H" "4H"])))
)

;11)(value hand)
(deftest test-value
 (is (= 4  (value ["AH" "2C" "3D" "4C" "5C"])))
 (is (= 2  (value ["9H" "9C" "JC" "AD" "AC"])))
 (is (= 6  (value ["2H" "5D" "2D" "2C" "5S"])))
 (is (= 7  (value ["2H" "2S" "2C" "2D" "7D"])))
 (is (= 1  (value ["2H" "2S" "4C" "5C" "7D"])))
  )

;12 (kickers hand)
(deftest test-kickers
 (is (= '(14 5 4 3 2) (kickers ["AH" "2C" "4C" "3D" "5C"]))) ;straight with A as 1
 (is (= '(6 5 4 3 2)  (kickers ["2H" "3S" "6C" "5D" "4D"]))) ;straght
 (is (= '(14 5 7) (kickers ["5H" "AD" "5C" "7D" "AS"]))) ;two-pairs
 (is (= '(9 14) (kickers ["9H" "9C" "9H" "AH" "AH"]))) ;full-house
 (is (= '(14 1) (kickers ["1C" "AH" "AH" "AH" "AH"])))  ;four-of-a-kind
 (is (= '(9 8 7 2 1) (kickers ["9H" "8H" "1H" "7H" "2H"]) )) ;flush
 (is (= '(14 2 1) (kickers ["1C" "2D" "AH" "AH" "AH"]))) ;three-of-a-kind
 (is (= '(14 3 2 1) (kickers ["1C" "2D" "3M" "AH" "AH"]))) ;pair
)


;13)higher-kicker
(deftest test-higher-kicker
 (is (false? (higher-kicker '(8 5 9) '(8 7 3)))) ;straight with A as 1
 (is (false? (higher-kicker '(8 5 9) '(8 5 9))))
 (is (true? (higher-kicker '(8 5 9) '(8 4 3))))
 (is (true? (higher-kicker '(8 9 9) '(8 9 3))))
)

;14)beats
(deftest test-beats?
 (is (true? (beats? ["9H" "9C" "9H" "AH" "AH"] ["1C" "2D" "3H" "7H" "JS"] ))) ;full house > ordinary hand
 (is (nil? (beats? ["9H" "9C" "9H" "AH" "AH"] ["9H" "9C" "9H" "AH" "AH"] ))) ;same hands - nil
 (is (true? (beats? ["9H" "9C" "9H" "AH" "AH"] ["AH" "2C" "4C" "3D" "5C"] ))) ;full-house > straight
 (is (true? (beats? ["TS" "AS" "QS" "KS" "KS"] ["1C" "2D" "3H" "7H" "JS"] ))) ;flush >  ordinary hand
)

;15)winning-hand
(deftest test-winning-hand
  (is (= nil (winning-hand)))
	(is (= '(["2S" "2D" "2C" "KC" "KH"]) (winning-hand ["3H" "AH" "4H" "5H" "7D"] ["2S" "2D" "2C" "KC" "KH"] ["AC" "KS" "2H" "3S" "AD"] ["9S" "8D" "TH" "6C" "7H"]))) ;full-house winner
  (is (= '(["AH" "2D" "3S" "4C" "TD"] ["AH" "2D" "3S" "4C" "TD"] ["AH" "2D" "3S" "4C" "TD"]) (winning-hand ["AH" "2D" "3S" "4C" "TD"] ["AH" "2D" "3S" "4C" "TD"] ["AH" "2D" "3S" "4C" "TD"]))) ;all same
  (is (= '(["3S" "3D" "3C" "KC" "KH"]) (winning-hand ["2S" "2D" "2C" "KC" "KH"] ["3S" "3D" "3C" "KC" "KH"]))) ;same values (full house), but bigger rank
	(is (= '(["3S" "3D" "3C" "KC" "KH"] ["3S" "3D" "3C" "KC" "KH"]) (winning-hand ["3S" "3D" "3C" "KC" "KH"] ["2S" "2D" "2C" "KC" "KH"] ["3S" "3D" "3C" "KC" "KH"]))))

(run-tests)
