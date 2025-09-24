;; EcoTracker: Decentralized Environmental Impact Tracking
;; A blockchain-based system for tracking and rewarding eco-friendly actions

(define-constant eco-admin tx-sender)
(define-constant err-admin-only (err u100))
(define-constant err-member-missing (err u101))
(define-constant err-access-denied (err u102))
(define-constant err-member-exists (err u103))
(define-constant err-no-profile (err u104))
(define-constant err-invalid-action (err u105))
(define-constant err-bad-input (err u106))

;; Valid eco actions
(define-data-var eco-actions (list 3 (string-ascii 24)) (list "recycling" "energy-save" "tree-plant"))

;; Core data structures
(define-map member-impact 
    principal 
    {
        green-score: uint,
        recycling-acts: uint,
        energy-saves: uint,
        last-activity: uint,
        tree-plants: uint
    }
)
(define-map action-rewards
    {action: (string-ascii 24)}
    {points: uint}
)

;; Set default reward points
(map-set action-rewards {action: "recycling"} {points: u10})
(map-set action-rewards {action: "energy-save"} {points: u5})
(map-set action-rewards {action: "tree-plant"} {points: u15})

;; Validation helpers
(define-private (is-valid-eco-action (action-type (string-ascii 24)))
    (is-some (index-of (var-get eco-actions) action-type))
)

;; Public functions
(define-public (join-eco-network)
    (begin
        (asserts! (is-none (get-member-impact tx-sender)) err-member-exists)
        (ok (map-set member-impact tx-sender {
            green-score: u0,
            recycling-acts: u0,
            energy-saves: u0,
            last-activity: stacks-block-height,
            tree-plants: u0
        }))
    )
)

(define-public (log-recycling)
    (let (
        (profile (unwrap! (get-member-impact tx-sender) err-no-profile))
        (points (get points (unwrap! (map-get? action-rewards {action: "recycling"}) err-invalid-action)))
    )
    (ok (map-set member-impact tx-sender (merge profile {
        green-score: (+ (get green-score profile) points),
        recycling-acts: (+ (get recycling-acts profile) u1),
        last-activity: stacks-block-height
    })))
    )
)

(define-public (log-energy-save)
    (let (
        (profile (unwrap! (get-member-impact tx-sender) err-no-profile))
        (points (get points (unwrap! (map-get? action-rewards {action: "energy-save"}) err-invalid-action)))
    )
    (ok (map-set member-impact tx-sender (merge profile {
        green-score: (+ (get green-score profile) points),
        energy-saves: (+ (get energy-saves profile) u1),
        last-activity: stacks-block-height
    })))
    )
)

(define-public (log-tree-planting)
    (let (
        (profile (unwrap! (get-member-impact tx-sender) err-no-profile))
        (points (get points (unwrap! (map-get? action-rewards {action: "tree-plant"}) err-invalid-action)))
    )
    (ok (map-set member-impact tx-sender (merge profile {
        green-score: (+ (get green-score profile) points),
        tree-plants: (+ (get tree-plants profile) u1),
        last-activity: stacks-block-height
    })))
    )
)

;; Admin functions
(define-public (update-eco-reward (action-type (string-ascii 24)) (new-points uint))
    (let
        (
            (max-points u1000)
            (validated-points (if (> new-points max-points) max-points new-points))
        )
        (begin
            (asserts! (is-eq tx-sender eco-admin) err-admin-only)
            (asserts! (is-valid-eco-action action-type) err-invalid-action)
            (ok (map-set action-rewards {action: action-type} {points: validated-points}))
        )
    )
)

;; Read-only functions
(define-read-only (get-member-impact (member principal))
    (map-get? member-impact member)
)

(define-read-only (get-action-points (action-type (string-ascii 24)))
    (map-get? action-rewards {action: action-type})
)

;; Helper function
(define-private (apply-time-decay (base uint) (time-span uint))
    (let (
        (decay-factor (/ time-span u1000))
    )
    (if (> decay-factor u0)
        (/ base decay-factor)
        base
    ))
)

;; Impact calculation with time decay
(define-read-only (get-current-impact (member principal))
    (let (
        (profile (unwrap! (get-member-impact member) err-member-missing))
        (inactivity (- stacks-block-height (get last-activity profile)))
    )
    (ok (apply-time-decay (get green-score profile) inactivity))
    )
)