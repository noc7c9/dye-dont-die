using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class AudioManager : MonoBehaviour {

        static AudioManager instance_;
        public static AudioManager Instance {
            get {
                if (instance_ == null) {
                    instance_ = FindObjectOfType<AudioManager>();
                }
                return instance_;
            }
        }

        public AudioSource music;
        public AudioSource source;

        public void PlaySound(AudioClip clip) {
            if (clip != null) {
                source.PlayOneShot(clip);
            }
        }

        public static void PlaySoundStatic(AudioClip clip) {
            Instance.PlaySound(clip);
        }

        public void SetMusicVolume(float volume) {
            music.volume = volume;
        }

    }

}
