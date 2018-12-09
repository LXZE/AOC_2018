(ns aoc7_1
	(:require
		[clojure.java.io :as io]
		[clojure.string :as str]))

(defn readfile []
	(->> (with-open [rdr (io/reader "input7.txt")]
			(reduce conj [] (line-seq rdr)))
		(map (fn [sentence]
			(mapv (str/split sentence #" ") [1 7])))))

(def data (apply list (readfile)))

(def cterm (frequencies (map (fn [x] (get x 1)) data)))

(defn sortchar [chars]
	(apply list (sort-by (juxt :count :char) chars))
)

(def allchar 
	(->> (distinct (flatten data))
		(map (fn [char]
			(hash-map :char char, :count (get cterm char 0))
		))
		(sortchar)
	)
)

(defn getnext [l]
	(nth (sortchar l) 0 nil)
)

(defn reducelist [char, actlist]
	(def res (group-by (fn [x]
		(some #(= char %) x)
		) actlist)
	)
	(def rm_act 
		(map (fn [x] (get x 1)) (res true)))
	{:newlist (apply list (res nil)), :rm rm_act}
)

(defn decchar [chars, rmlist]
	(loop [oldchar chars, rm rmlist]
		(def to_rm (str (first rm)))
		(def remain (rest rm))

		(def update_char
			(mapv (fn [elem]
				(if (= (elem :char) to_rm)
					(update-in elem [:count] dec)
					elem
				)
			) oldchar)
		)

		(if (empty? remain)
			(apply list update_char)
			(recur
				update_char
				remain
			)
		)
	)
)

(def result (loop [chars allchar, acc "", actlist data]

	(def action (get (getnext chars) :char))
	(def remain_chars (get (doall (split-at 1 chars)) 1))
	(def tmp (reducelist action actlist))
	(def newchars (decchar remain_chars (tmp :rm)))

	(if (= action nil)
		acc
		(recur
			(sortchar newchars)
			(str acc action)
			(tmp :newlist)
		)
	)
))


(println result)