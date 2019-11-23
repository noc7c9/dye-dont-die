using UnityEngine;
using UnityEngine.UI;

namespace Noc7c9.DyeDontDie {

    public class InputManager : MonoBehaviour {

        public InputButton uiLeftButton;
        public InputButton uiRightButton;
        public InputButton uiJumpButton;
        public InputButton[] uiStartButtons;

        private bool jumpLastFrame = false;
        private bool jumpThisFrame = false;

        void Update() {
            var jump = GetJump();
            jumpThisFrame = jump && !jumpLastFrame;
            jumpLastFrame = jump;
        }

        public long GetXAxis() {
            var horizontal = Input.GetAxisRaw("Horizontal");
            var keyboard = horizontal > 0.5 ? 1 : horizontal < -0.5 ? -1 : 0;

            var ui = (uiRightButton.IsDown() ? 1 : 0) - (uiLeftButton.IsDown() ? 1 : 0);

            return ui != 0 ? ui : keyboard;
        }

        public bool GetJump() {
            var keyboard = Input.GetKey(KeyCode.Space);
            var ui = uiJumpButton.IsDown();
            return ui || keyboard;
        }

        public bool GetJumpThisFrame() {
            return jumpThisFrame;
        }

        public bool GetStartDown() {
            var keyboard = Input.GetKeyDown(KeyCode.Space);
            var ui = false;
            foreach (var button in uiStartButtons) {
                ui = ui || button.IsDown();
            }
            return ui || keyboard;
        }

    }

}
