using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class CameraFollow : MonoBehaviour {

        public Transform target;

        float yOffset;

        void Start() {
            yOffset = transform.position.y - target.position.y;
        }

        void Update() {
            Vector3 newPosition = transform.position;
            var targetY = target.position.y + yOffset;
            if (targetY < newPosition.y) {
                newPosition.y = targetY;
            }
            transform.position = newPosition;
        }

    }

}
