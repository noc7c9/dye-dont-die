using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InputManager : MonoBehaviour {
    public InputButton uiLeftButton;
    public InputButton uiRightButton;
    public InputButton uiJumpButton;
    public InputButton[] uiStartButtons;

    public float GetXAxis() {
        float keyboard = Input.GetAxisRaw("Horizontal");
        float ui = (uiRightButton.Get() ? 1 : 0) - (uiLeftButton.Get() ? 1 : 0);

        return ui != 0 ? ui : keyboard;
    }

    public bool GetJump() {
        bool keyboard = Input.GetKey(KeyCode.Space);
        bool ui = uiJumpButton.Get();
        return ui || keyboard;
    }

    public bool GetJumpDown() {
        bool keyboard = Input.GetKeyDown(KeyCode.Space);
        bool ui = uiJumpButton.GetDown();
        return ui || keyboard;
    }

    public bool GetStartDown() {
        bool keyboard = Input.GetKeyDown(KeyCode.Space);
        bool ui = false;
        foreach (InputButton startButton in uiStartButtons) {
            ui = ui || startButton.GetDown();
        }
        return ui || keyboard;
    }
}
