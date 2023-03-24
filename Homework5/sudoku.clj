{:ime "TIJANA" :prezime "ATANASOVSKA" :index "196014"}

; Solve e glavnata funkcija koja ja povikuva transform. Vo transofrm se pravat proverkite sto treba da se izbrise. Poziciite na koi se mozni povekje vrednosti, se stava mnozestvo

;Solve prima matrica (vektor so vektori) so vrednosti od celi broevi i nuli kade sto treba da e prazno mesto. Vrakja matrica so resenie vrednosti, a ako na nekoja pozicija se povekje mozni, stava mnozestvo


;(ns user (:use clojure.test))


;Otkako so transform kje se smestat site sets, potoa se izminuvaat site elementi, pritoa za niv se znae broj na redica i kolona so brojaci.  Za sekoj element se povikuva: clean-row, clean-col, clean-square

(defn transform-helper [vector_] "Function which transforms vector with replacing 0 with set #{1 2 3 4 5 6 7 8 9}. If the head of the argument is 0, appends the set to the result of the recursion.
                                  If it's other number, it creates set of one element and appends to the result of the recursion."
                                (cond
                                  (empty? vector_) []
                                  (= 0 (first vector_)) (into [] (cons #{1 2 3 4 5 6 7 8 9} (transform-helper (rest vector_))))
                                  :else (into [] (cons (set (list (first vector_))) (transform-helper (rest vector_)) ))
                                ))



; Transform go prima istiot vlez so Solve.
  ; 1. Sekoj cel broj go stava vo mnozestvo so edna vrednost - toj broj
  ; 2. Sekoja 0 ja zamenuva so mnozestvo #{1 2 3 4 5 6 7 8 9}
(defn transform [matrix] "Iteration in the matrix row and calling transform-helper to replace zeros on row-level."
                          (cond
                             (empty? matrix) []
                             :else (into [] (cons (transform-helper (first matrix)) (transform (rest matrix))))
                             ))



(defn get-row [matrix numRow] "Returns row from the given matrix which is numRow in order. numRow >= 1.
                              Get-row if called with vector, returns the element in given position. If called with matrix, returns the row in given position"
                            (cond
                               (== numRow 1) (first matrix)
                               :else (get-row (rest matrix) (dec numRow))
                            ))

(defn get-element-in-row [row colNum] (get-row row colNum))


(defn get-element-in-matrix "Overrided function which is called with matrix and number of row and column of the wanted element. The facade calls the same function with iterator for rows.
                            Returns nil if no more rows are left for search."
              ([matrix rownum colnum]
                               (get-element-in-matrix matrix rownum colnum 1))
              ([matrix rownum colnum brRow]
                               (cond
                                 (empty? matrix) nil
                                 (= brRow rownum) (get-element-in-row (first matrix) colnum)
                                 :else (get-element-in-matrix (rest matrix) rownum colnum (inc brRow))
                                 )))


(defn member? [x lst] "Recursively iterating in the list and sub-lists to find the element. If found, returns true. If it comes to the end of the list, returns false."
                    (cond
                        (empty? lst) false
                        (= x (first lst)) true
                        (list? (first lst)) (or (member? x (first lst)) (member? x (rest lst)))
                        :else (member? x (rest lst))))

(defn remove-element [e lst] "Removes every occurence of given element in the given list. If the head of the list equals the element, skip it. Otherwise append it to the end result with cons."
                            (cond
                               (empty? lst) lst
                               (= e (first lst)) (remove-element e (rest lst))
                               :else (cons (first lst) (remove-element e (rest lst)))
                               ))


(defn clean-row [row numSet] "Function used to remove the given element (numSet) from all sets in the row. If the current set contains only one element, cannot be deleted. Otherwise use the upper function remove-element. "
                          ( cond
                               (empty? row) []
                               (= numSet (first row)) (cons (first row) (clean-row (rest row) numSet)) ;If the current set contains only one element, cannot be deleted
                               (member? (first numSet) (first row)) (cons (into #{} (remove-element (first numSet) (first row))) (clean-row (rest row) numSet))
                               :else (cons (first row) (clean-row (rest row) numSet))
                          ))

(defn clean-mtx-for-el-in-row "Function used to iterate in the matrix until the given row and call the function clean-row."
  ([matrix rowNum element]
                        (clean-mtx-for-el-in-row matrix rowNum element 1))
  ([matrix rowNum element brojac]
                        (cond
                             (empty? matrix) []
                             (= brojac rowNum)  (into [] (cons (into [] (clean-row (first matrix) element)) (clean-mtx-for-el-in-row (rest matrix) element (inc brojac))))
                             :else (into [] (cons (first matrix) (clean-mtx-for-el-in-row (rest matrix) rowNum element (inc brojac))))
                             )
                       ))


 ;--------------------------------------- cleaning rows solved


;Get-row if called with vector, returns the element in given position. IF called with matrix, returns the row in given position.

(defn get-column [matrix numCol] "Returns column from the given matrix which is numCol in order. numCol >= 1."
                          (cond
                                (empty? matrix) []
                                :else (into[] (cons (get-element-in-row (first matrix) numCol) (get-column (rest matrix) numCol)))
                                 ))


(defn clean-column [column numSet] "To clean column from given element is the same as cleaning row because of the upper function get-column which returns column from matrix as vector."
                                (into [] (clean-row column numSet)))


(defn set-element-in-row "Given row and element puts the element in the given position. "
  ([row element position]
                       (set-element-in-row row element position 1))
  ([row element position brojac]
                        (cond
                              (empty? row) []
                              (= position brojac) (cons element (rest row))
                              :else (cons (first row) (set-element-in-row (rest row) element position (inc brojac)))
                        )))

(defn clean-mtx-for-el-in-column "Function used to iterate in the matrix until the given row and call the function clean-row."
  ([matrix numSet numCol] ;(clean-column (get-column matrix numCol) numSet))
   (clean-mtx-for-el-in-column matrix numCol (clean-column (get-column matrix numCol) numSet) 1))
  ([matrix numCol cleanedCol brRow] (cond
                                          (empty? matrix) []
                                          :else (cons (set-element-in-row (first matrix) (first cleanedCol) numCol 1) (clean-mtx-for-el-in-column (rest matrix) numCol (rest cleanedCol) (inc brRow)) )
                                            )))


;--------------------------cleaning columns solved

;For every element in the matrix, calculate square-number. Those with same square-number, should be cleaned from duplicates.
;calculateSquare sees the matrix as 3x3, where (1,1)=1 (4,1)=2

(defn calculateSquare [elCol elRow] "Given number of column and row, returns the square number." (+ (quot (- elCol 1) 3) (* (quot (- elRow 1) 3) 3) 1) )

;for square it's easier to directly clean the square then returning elements as row and then cleansing.
; Square values are [0,..,8]

(defn clean-row-of-square "Iterates in row and calculates square number for every element. If the element has same square number as the argument, it is cleaned."
  ([row rowNum numSet squareNum] (clean-row-of-square row rowNum numSet squareNum 1))
   ([row rowNum numSet squareNum iterCol]
    (cond
          (empty? row) []
          (= numSet (first row)) (cons (first row) (clean-row-of-square (rest row) rowNum numSet squareNum (inc iterCol)))
          (= (calculateSquare iterCol rowNum) squareNum) (cons (into #{} (remove-element (first numSet) (first row))) (clean-row-of-square (rest row) rowNum numSet squareNum (inc iterCol)))
          :else (cons (first row) (clean-row-of-square (rest row) rowNum numSet squareNum (inc iterCol)))
  )))


(defn remove-from-square "Calculates the square number for given element. Iterates in rows and calls clean-row-of-square."
  ([matrix numSet elRow elCol] (remove-from-square matrix numSet elRow elCol 1 (calculateSquare elCol elRow)))
  ([matrix numSet elRow elCol iterRow squareNum](
   cond
   (empty? matrix) []
    :else (into [] (cons (into [] (clean-row-of-square (first matrix) iterRow numSet squareNum)) (remove-from-square (rest matrix) numSet elRow elCol (inc iterRow) squareNum))
  ))))


;------------------------cleaning squares solved


(defn solve-part1 "Iterates in the matrix and cleans every element with calling the upper function."
  ([matrix] (solve-part1 matrix 1 1))
  ([matrix iterRow iterCol]
   ( let [currentElement (get-element-in-matrix matrix iterRow iterCol)]
        (cond
          (= iterRow 10) matrix
          (= iterCol 10) (solve-part1 matrix (inc iterRow) 1)
          (= (count currentElement) 1)  (solve-part1 (remove-from-square (clean-mtx-for-el-in-column (clean-mtx-for-el-in-row matrix iterRow currentElement) currentElement iterCol) currentElement iterRow iterCol) iterRow (inc iterCol))  ;ako e eden element iscisti gi drugite vakvi elementi od redicata
          :else (solve-part1 matrix iterRow (inc iterCol))
          ))))


;The upper function solve-part1 is tested via this function because first we need to call transform on the input matrix
(defn solve-part1-test [matrix] "Transforms the matrix with calling transform and then cleans elements in rows, cols and squares."
                   (let [mtx (transform matrix)]
                    (solve-part1 mtx)))
;------------------------part 1 solved


(defn get-square "Returns vector of all elements in the given square. Calculates the square for iterRow and iterCol, if the square is same as the argument, the element is appended."
  ([matrix squareNum] (get-square matrix squareNum 1 1))
  ([matrix squareNum iterRow iterCol] (cond
                                        (= iterRow 10) []
                                        (= iterCol 10) (get-square (rest matrix) squareNum (inc iterRow) 1)
                                        (= squareNum (calculateSquare iterRow iterCol)) (cons (get-element-in-row (first matrix) iterCol) (get-square matrix squareNum iterRow (inc iterCol)))
                                        :else (get-square matrix squareNum iterRow (inc iterCol))
                                        ))
  )


(defn remove-nth-element  [row n] "Remove n-th element in the given row."
                                (cond
                                     (= n 1) (rest row)
                                     :else (cons (first row) (remove-nth-element  (rest row) (dec n)))))

(defn is-unique [matrix value rowNum colNum squareNum] "Boolean function which checks if the given value (int, not set of values!) is unique in the row, column and square in which belongs. Returns nil if not unique."
  (
    and
    (if (= '() (for [x (remove-nth-element (get-row matrix rowNum) colNum) :when (member? value x)] false)) true)
    (if (= '() (for [x (remove-nth-element (get-column matrix colNum) rowNum) :when (member? value x)] false)) true)
    (if (= '() (for [x (remove-nth-element (get-square matrix squareNum) (+ (* 3 (dec rowNum)) colNum)) :when (member? value x)] false)) true)
  ))


 (defn set-element-in-matrix "Sets the given element in a position rowNum, colNum. Iterates in the matrix and calls set-element-in-row for the needed row."
   ([matrix el rowNum colNum] (set-element-in-matrix matrix el rowNum colNum 1))
   ([matrix el rowNum colNum rowIter] (cond
                                        (= rowNum rowIter) (cons (into '[] (set-element-in-row (first matrix) el colNum 1)) (rest matrix))
                                        :else (cons (first matrix) ( set-element-in-matrix (rest matrix) el rowNum colNum (inc rowIter)))
   )))



(defn has-unique [matrix element row column squareNum] "Checks if the element-set which has more values, contains unique value, compared with the values in its row, col and square. If it does, returns one-element set with the value."
  (cond
    (empty? element) false
    (true? (is-unique matrix (first element) row column squareNum)) (into #{} (list (first element)))
    :else (has-unique matrix (rest element) row column squareNum)
  ))




(defn solve-part2 "Iterate in the matrix and for every set-element with more then one value in it, check if it has unique value. If it does replace the element with one-element set. If it doesn't have unique value
                    or it has 1 element, continue."
  ([matrix] (solve-part2 matrix 1 1))
  ([matrix iterRow iterCol]
   ( let [currentElement (get-element-in-matrix matrix iterRow iterCol)]
        (cond
          (= iterRow 10) matrix
          (= iterCol 10) (solve-part2 matrix (inc iterRow) 1)
          (not= (count currentElement) 1)  (let [has-unique-val (has-unique matrix currentElement iterRow iterCol (calculateSquare iterCol iterRow))]
                                                       (cond
                                                          (set? has-unique-val) (solve-part2 (set-element-in-matrix matrix has-unique-val iterRow iterCol) iterRow (inc iterCol))
                                                          (false? has-unique-val) (solve-part2 matrix iterRow (inc iterCol))
                                                          ))  ;ako ne e eden element, proveri unikatnost. Ako vrate set znaci ima unikatna vrednost. Ako vrate false, nema
          :else (solve-part2 matrix iterRow (inc iterCol))
  ))))


;----------------------------------------------- final solution

(defn recursive-solve [matrix] "Function implementing while cycle to iterate in two parts of the solution. Every time it calls the two main functions and if there are changes, then recursive call is created."
  (let [solution (solve-part2 (solve-part1 matrix))]
   (cond
       (= solution matrix) solution
       :else (recursive-solve solution)
  )))

(use 'clojure.inspector)
(defn replace_0 [row] (replace {0 ""} row))

;VISUALIZATION!
(defn show [matrix] (inspect-table (map replace_0 matrix)))

(defn solve [matrix]
      (show matrix)
     (let [mtx (transform matrix)]
      (recursive-solve mtx)
      ))
