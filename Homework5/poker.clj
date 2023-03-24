{:ime "TIJANA" :prezime "ATANASOVSKA" :index "196014"}

;card = string of 2 chars -> "2C"= 2 Clubs
;values = (Clubs, Diamonds, Hearts, Spades)

;1) (suit card)->color of card
(defn suit [card] (str(second card)))


;2) (rank card)->rank of card (ex: "JH" -> Jack = 11)
(defn rank [card] (
                    let [firstLetter (first card)
                          mapa {\T 10, \J 11, \Q 12, \K 13, \A 14}
                          ]
                    (cond
                      (Character/isDigit firstLetter) (Integer/valueOf (str firstLetter))
                    :else (mapa firstLetter)
                      )
                    ))


;hand = vector of EXACTLY 5 cards (ex: ["1C" "2D" "AH" "AH" "AH"])

;3) (pair? hand) returns true if  EXACTLY 2 cards are same

(defn pair? [hand] "Logic: ako nema vrednost pogolema od 2 vo frequesncies i postoi tocna edna dvojka, togas e pair"
                (let [ freqs (frequencies (map rank hand))]
                     (cond
                     (not (empty? (filter #(> % 2) (vals freqs)))) false
                     (== 1 (count (filter #(== % 2) (vals freqs)))) true
                      :else false
                     )))



;4)(three-of-a-kind? hand)
(defn three-of-a-kind? [hand] "Logic: Ako ima 3 isti karti i dve razlicni e true. Se proveruva dali frequencies ima vrednost 3 (znaci nekoja karta se pojavila 3 pati) i dve vrednosti 1."
                (let [ freqs (frequencies hand)]
                     (cond

                     (and (== 1 (count (filter #(== % 3) (map second freqs)))) (== 2 (count (filter #(== % 1) (map second freqs))))) true
                        :else false
                     )))


;5)(four-of-a-kind? hand)
(defn four-of-a-kind? [hand] "Logic: Ako ima 4 isti karti e true. Se proveruva dali frequencies ima vrednost 4 (znaci nekoja karta se pojavila 4 pati). Ako se pojavuva 5 pati kje vrate false."
                (let [ freqs (frequencies (map rank hand))]
                     (cond
                     ;Ako ima 4 isti uslovot e zadovolen
                      (== 1 (count (filter #(== % 4) (vals freqs)))) true
                        :else false
                     )))


;6) (flush? hand)
(defn flush? [hand] "Logic: Ako site se so ista boja ova: (vals (frequencies (map suit hand))) -> kje vrate lista so edna 5ka vnatre. Potoa se proveruva redosledot - se zema najmalata od vrednostite vo kartite
                            i se kreira niza od nea do slednite 5 karti. Ako nizata e ista so vleznite karti znaci deka se posledovatelni i vrakja false."(
                      let [ranks (sort (map rank hand))]
                        (cond
                            (= (range (first ranks) (+ (first ranks) 5)) ranks) false
                            (= 5 (first (vals (frequencies (map suit hand))))) true
                            :else false
                      )))



;7) (full-house? hand) ->

(defn full-house? [hand] "Ako mu se izbrojat vrednostite na broevi (so frequencies) i se podredat togas mora da bide (2 3) ako vazi full house. "
  (
                      let [ freqs (frequencies (map rank hand))]

                        (cond
                            (= '(2 3) (sort (vals freqs))) true
                            :else false
                      )))


;8)(two-pairs? hand)
(defn two-pairs? [hand] "Ako mu se izbrojat vrednostite na broevi (so frequencies) i se podredat togas mora da bide (1 2 2) ako vazi two pairs."(
                      let [ freqs (frequencies (map rank hand))]

                        (cond
                          (full-house? hand) false
                          (= '(1 2 2) (sort (vals freqs))) true
                          :else false
                      )))


;9) (straight? hand)

(defn straight? [hand] "Prviot uslov: dali podreduvanje na vrednostite e isto sto i kreiranje na sekvenca so dolzina 5 kade prv element e first of podredenata niza ranks.
                          Vtor uslov: Ako poslednata vrednost vo sortirana niza e 14, a prvite 4 elementi od ranks se (2 3 4 5) togas e true bidejki 14 e 1 vo toj slucaj. "
  (
                          let [ ranks (sort (map rank hand))]
                         (cond
                            (= (range (first ranks) (+ (first ranks) 5)) ranks) true
                            (and (= (last ranks) 14) (= (range 2 6) (take 4 ranks) )) true
                            :else false
                      )))


;10)(straight-flush? hand)
(defn straight-flush? [hand] (
                               and (straight? hand) (= 5 (first (vals (frequencies (map suit hand))))) ;(flush? hand)
                               ))


;11) (value hand)

(defn value [hand] "juxt primenuva niza od funkcii vrz edna vrednost. Rezultatite se zacuvani vo resuslts, a potoa spored soodvetniot flag se vrakja odgovor"
  (
                     let [results ((juxt pair? two-pairs? three-of-a-kind? straight? flush? full-house? four-of-a-kind? straight-flush?) hand)]
                     (cond
                       (every? false? results) 0
                       (true? (nth results 7)) 8
                       (true? (nth results 6)) 7
                       (true? (nth results 5)) 6
                       (true? (nth results 4)) 5
                       (true? (nth results 3)) 4
                       (true? (nth results 2)) 3
                       (true? (nth results 1)) 2
                       (true? (nth results 0)) 1
                       )
                     ))



;12) kickers hand
(defn sorted-by-vals [mapa] "returns sorted map compared by values" (
                           into (sorted-map-by >) mapa
                             ))

(defn kickers [hand] (
                       let [valueHand (value hand)
                             ranks (map rank hand) ]
                       (print valueHand)
                       (cond
                         (some #{valueHand} '(4 5 8)) (reverse (sort ranks))  ;straight, flush, и straight-flush
                         (= 2 valueHand) (concat (keys (reverse (rest (sort-by second (frequencies ranks))))) (keys (list (first (sort-by second (frequencies ranks)))))) ;two pairs
                         (= 6 valueHand) (keys (sort (frequencies ranks))) ;full-house
                         (= 7 valueHand) (keys (sorted-by-vals (frequencies ranks))) ;four-of-a-kind
                         (= 3 valueHand) (keys (sorted-by-vals (frequencies ranks))) ;three-of-a-kind
                         (= 1 valueHand) (keys (sorted-by-vals (frequencies ranks))) ;pair
                         :else  (keys (sorted-by-vals (frequencies ranks)))
                         )
                       ))


;13 higher-kicker

(defn higher-kicker-helper [kicker1 kicker2] ( cond
                                        (empty? kicker1) true  ;Pretpostavete deka dvete listi se so ista dolzina. Zatoa nema potreba da se proveruvaat dvete
                                        (= (first kicker1) (first kicker2)) (higher-kicker-helper (rest kicker1) (rest kicker2))
                                        (< (first kicker1) (first kicker2)) false
                                        :else (higher-kicker-helper (rest kicker1) (rest kicker2))))

;Se koristi pomosna funkcija za da uslovot dali se celosno isti nizite se proveri samo ednas, na pocetok. Ako se koristi samo edna funkcija, kje vrakja false za (8 5 2) (7 5 2) -> 8>7 i potoa (5 2) == (5 2)
(defn higher-kicker [kicker1 kicker2] (cond
                                        (= kicker1 kicker2) false
                                        :else (higher-kicker-helper kicker1 kicker2)
                                        ))

;14) beats?
(defn beats? [hand1 hand2] (cond
                             (> (value hand1) (value hand2)) true
                             (true? (higher-kicker (kickers hand1) (kickers hand2))) true
                             :else nil
                             ))


;15)winning-hand
;Hands e lista od site argumenti zadadeni na vlez. Argumentite pred &, ne spagjaat vo hands
(defn winning-hand-helper [rest-hands winner]
                              (cond
                                (empty? rest-hands) (list winner)
                                (true? (beats? winner (first rest-hands))) (winning-hand-helper (rest rest-hands) winner)
                                (true? (beats? (first rest-hands) winner)) (winning-hand-helper (rest rest-hands) (first rest-hands))
                                :else (cons (first rest-hands) (winning-hand-helper (rest rest-hands) winner))
                               ))
(defn winning-hand [& hands] ( cond
                               (empty? hands) nil
                               :else (winning-hand-helper (rest hands) (first hands))))





















