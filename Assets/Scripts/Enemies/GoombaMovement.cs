using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class GoombaMovement : MonoBehaviour {

        const float OVERLAP_SPHERE_RADIUS = 0.05f;

        public float speed;
        public float pathCheckOffset;
        public LayerMask collisionMask;

        Rigidbody2D rb;

        float moveDir = 1;

        void OnDrawGizmos() {
            Gizmos.color = Color.red;

            Vector2 position = transform.position;
            position.x += moveDir * pathCheckOffset;
            Gizmos.DrawWireSphere(position, OVERLAP_SPHERE_RADIUS);
            position.y -= pathCheckOffset;
            Gizmos.DrawWireSphere(position, OVERLAP_SPHERE_RADIUS);

            position = transform.position;
            position.y -= pathCheckOffset;
            Gizmos.DrawWireSphere(position, OVERLAP_SPHERE_RADIUS);
        }

        void Start() {
            rb = GetComponent<Rigidbody2D>();
        }

        void FixedUpdate() {
            var newVelocity = rb.velocity;

            if (OnGround()) {
                CheckCollision();

                newVelocity.x = moveDir * speed * Time.deltaTime;
                rb.velocity = newVelocity;
            }
        }

        bool OnGround() {
            var position = transform.position;
            position.y -= pathCheckOffset;
            return null != Physics2D.OverlapCircle(position,
                    OVERLAP_SPHERE_RADIUS, collisionMask);
        }

        void CheckCollision() {
            var position = transform.position;

            // check for walls
            position.x += moveDir * pathCheckOffset;
            var hit = Physics2D.OverlapCircle(position,
                    OVERLAP_SPHERE_RADIUS, collisionMask);
            if (hit != null) {
                moveDir = -moveDir;
            }

            // check for drops
            position.y -= pathCheckOffset;
            hit = Physics2D.OverlapCircle(position,
                    OVERLAP_SPHERE_RADIUS, collisionMask);
            if (hit == null) {
                moveDir = -moveDir;
            }
        }

    }

}
