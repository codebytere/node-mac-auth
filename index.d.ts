// Type definitions for node-mac-auth
// Project: node-mac-auth

declare module 'node-mac-auth' {
  export function canPromptTouchID(): boolean;

  export function promptTouchID(options: {
    reason: string;
    reuseDuration?: number;
  }): Promise<void>;
}
