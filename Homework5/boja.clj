{:ime "TIJANA" :prezime "ATANASOVSKA" :index "196014"}

(ns user (:use clojure.test))

(defn rotate [lst] "Puts the last element as first in the list"
              (cons (last lst) (drop-last lst)))

(defn different_colors [list-of-lists] "Predicate function to check if the rotatation of the colors in the given lists is a solution. Gets matrix as argument." (
                    let [firstColors (map first list-of-lists) ]
                    (cond
                      (empty? (first list-of-lists)) true
                      (apply distinct?  firstColors)  (different_colors (map rest list-of-lists))
                      :else false
                      )))

;len = dolzina na edna lista - kolku boi ima
;Rotacija na edna lista i sporedba so ostatokot od listite. Ako za nitu edno rotiranje na listata ne se razlicni so ostanatite listi, vrakja false
(defn rotate_len_times [len list-of-lists]
                  (cond
                    (= len 0) false
                    (true? (different_colors list-of-lists)) list-of-lists
                    :else (rotate_len_times (dec len) (cons (rotate (first list-of-lists)) (rest list-of-lists)))
                    ))

(defn first_non_zero "returns position of first non zero eleemnt in the list"
  ([state_list] (first_non_zero state_list 1))
   ([state_list counter] (cond
                           (empty? state_list) false
                           (zero? (first state_list)) (first_non_zero (rest state_list) (inc counter))
                           :else counter )))

(defn update_state [state_list] "decrease first non zero number in the list representing state"
  (cond
    (zero? (first state_list)) (cons (first state_list) (update_state (rest state_list)))
    :else (cons (dec (first state_list)) (rest state_list))
    ))

(defn nth-element [list-of-lists n] (nth list-of-lists (dec n))) ;mora so dec bidejki nth pocnuva da broe od 0ta pozicija

(defn rotate_current "Rotate list which is on position Current in the matrix"
  ([list-of-lists current] (rotate_current list-of-lists current 1))
  ([list-of-lists current counter]
    (cond
      (= counter current) (concat (list (rotate (first list-of-lists))) (rest list-of-lists))
      :else (concat (list (first list-of-lists)) (rotate_current (rest list-of-lists) current (inc counter)))
    )))

(defn rotate_rest_lists [first_list len rest_lists rest_state] "If all are zeros in the state, return false, no solution. Otherwise rotate len times the first list and if no solution is found rotate the list which has left rotation based on state!"
  (let [rotated (rotate_len_times len (cons first_list rest_lists))]
  (cond
    (false? (first_non_zero rest_state)) false

    ;rotate the first list len times.
    (seq? rotated) rotated ;Ako rotate_len_times vrate lista znaci se nashlo resenie i go vrakjame nego. Ako vrate false odime edno nivo podole

    ;rotate the list from rest_list which is not rotated len times and call again this function to rotate len times the first list
    :else (rotate_rest_lists first_list len (rotate_current rest_lists (first_non_zero rest_state)) (update_state rest_state))
  )))

(defn rotation-helper [list-of-lists]  "helper function to initialize state-list."
  (cond
                                         (= 1 (count list-of-lists)) list-of-lists
                                         :else (rotate_rest_lists (first list-of-lists) (count (first list-of-lists)) (rest list-of-lists) (take (count (rest list-of-lists)) (repeat (count (first list-of-lists)))))
                                        ))

;Glavnoto rotiranje na site listi. Odi do poslednoto i na vrakjanje rotiraj gi listite i ako najde solution vrati go toj.
(defn solve [list-of-lists]
  (cond
                                (= 1 (count list-of-lists)) list-of-lists
                                (false? (rotation-helper (solve (rest list-of-lists)))) false
                                :else (rotation-helper (cons (first list-of-lists) (solve (rest list-of-lists)))
      )))



(use 'clojure.inspector)

;VISUALIZATION!
(defn show [matrix] (inspect-table matrix))
(show (solve '((3 1 2 4 0) (4 0 3 2 1))))

