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

        public void StartAnimation() {
            Rigidbody2D rb = GetComponent<Rigidbody2D>();

            GetComponent<Collider2D>().enabled = false;

            rb.constraints = RigidbodyConstraints2D.None;

            float dir = Random.value > 0.5 ? 1 : -1;

            float angle = dir * Random.Range(minForceAngle, maxForceAngle);
            Vector2 force = Vector2.up
                * Random.Range(minForceMagnitude, maxForceMagnitude);
            force = Quaternion.Euler(0, 0, angle) * force;
            rb.AddForce(force, ForceMode2D.Impulse);

            rb.AddTorque(dir * Random.Range(minTorque, maxTorque));

            rb.gravityScale = gravityScale;
        }

    }

}
