using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    [RequireComponent(typeof(Rigidbody2D))]
    public class MaxVerticalVelocity : MonoBehaviour {

        public float maxVerticalVelocity;

        Rigidbody2D rb;

        void Awake() {
            rb = GetComponent<Rigidbody2D>();
        }

        void Update() {
            Vector2 newVelocity = rb.velocity;

            newVelocity.y = Mathf.Clamp(newVelocity.y,
                    -maxVerticalVelocity, maxVerticalVelocity);

            rb.velocity = newVelocity;
        }

    }

}
