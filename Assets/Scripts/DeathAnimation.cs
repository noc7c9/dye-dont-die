using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    [RequireComponent(typeof(Rigidbody2D))]
    public class DeathAnimation : MonoBehaviour {

        public float minTorque;
        public float maxTorque;

        public float minForceAngle;
        public float maxForceAngle;

        public float minForceMagnitude;
        public float maxForceMagnitude;

        public float gravityScale;

        private Rigidbody2D rb;
        private Collider2D col;

        void Start() {
            rb = GetComponent<Rigidbody2D>();
            col = GetComponent<Collider2D>();
        }

        public void StartAnimation() {
            col.enabled = false;
            rb.bodyType = RigidbodyType2D.Dynamic;
            rb.constraints = RigidbodyConstraints2D.None;

            var dir = Random.value > 0.5 ? 1 : -1;

            var angle = dir * Random.Range(minForceAngle, maxForceAngle);
            Vector2 force = Vector2.up
                * Random.Range(minForceMagnitude, maxForceMagnitude);
            force = Quaternion.Euler(0, 0, angle) * force;

            rb.AddForce(force, ForceMode2D.Impulse);
            rb.AddTorque(dir * Random.Range(minTorque, maxTorque));
            rb.gravityScale = gravityScale;
        }

    }

}
