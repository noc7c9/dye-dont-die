using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class InputButton : MonoBehaviour, IPointerDownHandler, IPointerUpHandler {

    bool isDown = false;
    bool isDownFrame = false;

    public void LateUpdate() {
        isDownFrame = false;
    }

    public void OnDisable() {
        isDown = false;
        isDownFrame = false;
    }

    public void OnEnable() {
        isDown = false;
        isDownFrame = false;
    }

    public void OnPointerDown(PointerEventData eventData) {
        isDown = true;
        isDownFrame = true;
    }

    public void OnPointerUp(PointerEventData eventData) {
        isDown = false;
    }

    public bool Get() {
        return isDown;
    }

    public bool GetDown() {
        return isDownFrame;
    }

}
