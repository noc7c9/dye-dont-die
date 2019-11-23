using UnityEngine;
using Prime31;

namespace Noc7c9.DyeDontDie {

    [RequireComponent(typeof(CharacterController2D))]
    [RequireComponent(typeof(DeathAnimation), typeof(Rigidbody2D), typeof(Collider2D))]
    public class PlayerController : MonoBehaviour {

        // Movement config
        public float gravity = -25f;
        public float runSpeed = 8f;
        public float groundDamping = 20f; // how fast do we change direction? higher means faster
        public float inAirDamping = 5f;
        public float jumpHeight = 3f;

        public AudioClip jumpSound;
        public AudioClip playerDeathSound;

        private CharacterController2D controller;
        private Vector3 velocity;

        public event System.Action Died;
        void OnDied() {
            var evt = Died;
            if (evt != null) {
                evt();
            }
        }

        public void Die() {
            GetComponent<DeathAnimation>().StartAnimation();
            enabled = false;

            Died();

            AudioManager.PlaySoundStatic(playerDeathSound);
        }

        public void Reset() {
            GetComponent<Rigidbody2D>().bodyType = RigidbodyType2D.Kinematic;
            GetComponent<Collider2D>().enabled = true;
            enabled = true;
            transform.position = Vector3.zero;
        }

        void Start() {
            controller = GetComponent<CharacterController2D>();
        }

        void Awake() {
            controller = GetComponent<CharacterController2D>();
        }

        void Update() {
            var input = ServiceLocator.InputManager;

            if (controller.isGrounded) {
                velocity.y = 0;
            }

            var right = Input.GetKey(KeyCode.RightArrow);
            var left = Input.GetKey(KeyCode.LeftArrow);
            var up = Input.GetKey(KeyCode.UpArrow);

            var horizontalInput = input.GetXAxis();
            var jumpInput = input.GetJump();

            // the color changes regardless of whether the player is grounded or
            // not
            if (input.GetJumpThisFrame()) {
                ServiceLocator.WorldColorManager.CycleColor();
            }

            // we can only jump whilst grounded
            if (controller.isGrounded && jumpInput) {
                velocity.y = Mathf.Sqrt(2f * jumpHeight * -gravity);
            }

            // apply horizontal speed smoothing it. dont really do this with Lerp.
            // Use SmoothDamp or something that provides more control

            // how fast do we change direction?
            var smoothedMovementFactor = controller.isGrounded ? groundDamping : inAirDamping;

            velocity.x = Mathf.Lerp(velocity.x,
                    horizontalInput * runSpeed,
                    Time.deltaTime * smoothedMovementFactor);

            // apply gravity before moving
            velocity.y += gravity * Time.deltaTime;

            controller.move(velocity * Time.deltaTime);

            // grab our current velocity to use as a base for all calculations
            velocity = controller.velocity;
        }
    }

}
