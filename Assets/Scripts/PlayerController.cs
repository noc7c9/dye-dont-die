using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    [RequireComponent(typeof(Rigidbody2D))]
    [RequireComponent(typeof(BoxCollider2D))]
    public class PlayerController : MonoBehaviour {

        public float horizontalMaxSpeed;
        public float horizontalAcceleration;
        public float jumpVelocity;
        public float maxJumpTime;
        public bool killHorizontalVelocity;

        public LayerMask collisionMask;

        public Vector2 groundCheckCenter;
        public Vector2 groundCheckSize;

        public AudioClip jumpSound;
        public AudioClip playerDeathSound;

        public InputManager input;

        public event System.Action Died;
        void OnDied() {
            var evt = Died;
            if (evt != null) {
                evt();
            }
        }

        bool touchingGround;
        float jumpTime;
        bool jumping;
        bool jumpInputReleased = true;

        Rigidbody2D rb;

        void Start() {
            rb = GetComponent<Rigidbody2D>();
        }

        void OnDrawGizmos() {
            Gizmos.color = Color.red;
            Vector2 position = transform.position;
            Gizmos.DrawWireCube(position + groundCheckCenter, groundCheckSize);
        }

        void Update() {
            // cycle colors
            if (input.GetJumpDown()) {
                GameManager.Instance.CycleColor();
            }
        }

        void FixedUpdate() {
            Vector2 newVelocity = rb.velocity;

            OnGroundCheck();

            HorizontalMovement(ref newVelocity);
            JumpMovement(ref newVelocity);

            rb.velocity = newVelocity;
        }

        void OnGroundCheck() {
            Vector2 position = transform.position;
            touchingGround = null != Physics2D.OverlapBox(
                    position + groundCheckCenter, groundCheckSize,
                    0, collisionMask);
        }

        void HorizontalMovement(ref Vector2 newVelocity) {
            float inputX = input.GetXAxis();

            // kill velocity if touching the ground and there is no input
            // or if changing moving direction
            if (killHorizontalVelocity) {
                if ((inputX == 0 && touchingGround)
                        || Mathf.Sign(inputX) != Mathf.Sign(newVelocity.x)) {
                    newVelocity.x = 0;
                }
            }
            newVelocity.x += inputX * horizontalAcceleration;
            newVelocity.x = Mathf.Clamp(newVelocity.x,
                    -horizontalMaxSpeed, horizontalMaxSpeed);
        }

        void JumpMovement(ref Vector2 newVelocity) {
            bool jumpInput = input.GetJump();

            if (touchingGround && jumpInput && jumpInputReleased) {
                jumping = true;
                jumpInputReleased = false;
                jumpTime = 0;
                AudioManager.PlaySoundStatic(jumpSound);
            }
            if (!jumpInput && !jumpInputReleased) {
                jumpInputReleased = true;
            }

            if (jumping) {
                jumpTime += Time.deltaTime;
                if (!jumpInput || jumpTime > maxJumpTime) {
                    jumping = false;
                } else {
                    newVelocity.y = jumpVelocity;
                }
            }
        }

        public void Die() {
            rb.velocity = Vector2.zero;
            GetComponent<DeathAnimation>().StartAnimation();
            enabled = false;

            Died();

            AudioManager.PlaySoundStatic(playerDeathSound);
        }

        public void Reset() {
            rb.constraints = RigidbodyConstraints2D.FreezeRotation;
            rb.rotation = 0;

            GetComponent<Collider2D>().enabled = true;
            enabled = true;
        }

    }

}
